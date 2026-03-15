<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/header.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>

<style>
    .chat-room-wrapper { max-width: 600px; margin: 30px auto; border: 1px solid #ddd; border-radius: 10px; overflow: hidden; display: flex; flex-direction: column; height: 700px; }
    .chat-header { background: #FF6F61; color: white; padding: 15px; font-weight: bold; text-align: center; position: relative; }
    .chat-header button { position: absolute; right: 15px; top: 12px; background: white; color: #FF6F61; border: none; padding: 5px 10px; border-radius: 5px; cursor: pointer; font-weight: bold; }
    
    .chat-messages { flex-grow: 1; padding: 15px; background: #f5f6fa; overflow-y: auto; }
    .msg-box { display: flex; margin-bottom: 15px; }
    .msg-box.me { flex-direction: row-reverse; }
    .msg-content { max-width: 70%; padding: 10px 15px; border-radius: 15px; font-size: 14px; line-height: 1.4; word-break: break-all; }
    .msg-box.me .msg-content { background: #FF6F61; color: white; border-top-right-radius: 2px; }
    .msg-box.other .msg-content { background: white; color: #333; border: 1px solid #ddd; border-top-left-radius: 2px; }
    
    .chat-input-area { display: flex; padding: 15px; background: white; border-top: 1px solid #ddd; }
    .chat-input-area input { flex-grow: 1; padding: 10px; border: 1px solid #ccc; border-radius: 5px; outline: none; }
    .chat-input-area button { margin-left: 10px; padding: 10px 20px; background: #333; color: white; border: none; border-radius: 5px; cursor: pointer; }
</style>

<div class="chat-room-wrapper">
    <div class="chat-header">
        채팅방
        <button type="button" id="btnPay">결제/송금하기</button>
    </div>

    <div class="chat-messages" id="chatArea">
        </div>

    <div class="chat-input-area">
        <input type="text" id="msgInput" placeholder="메시지를 입력하세요..." onkeypress="if(event.keyCode==13) sendMsg();">
        <button type="button" onclick="sendMsg()">전송</button>
    </div>
</div>

<script>
    let stompClient = null;
    const roomId = "${param.room_id}"; // URL 파라미터에서 가져옴
    const myId = "${loginInfo.member_id}";
    const myNickname = "${loginInfo.nickname}";

    $(document).ready(function() {
        connect(); // 페이지 로드 시 웹소켓 연결
        loadHistory(); // 과거 메시지 불러오기
    });

    // 1. 웹소켓 연결
    function connect() {
        const socket = new SockJS('/ws-stomp');
        stompClient = Stomp.over(socket);
        
        stompClient.connect({}, function (frame) {
            console.log('Connected: ' + frame);
            
            // 해당 채팅방 구독 (메시지가 오면 실행될 콜백)
            stompClient.subscribe('/sub/chat/room/' + roomId, function (message) {
                const recvMsg = JSON.parse(message.body);
                drawMessage(recvMsg);
            });
        });
    }

    // 2. 메시지 전송
    function sendMsg() {
        const text = $("#msgInput").val().trim();
        if(text === "") return;

        const chatMessage = {
            room_id: roomId,
            sender_id: myId,
            message_text: text,
            sender_nickname: myNickname // 화면 표시용
        };

        // 서버로 메시지 발행(Publish)
        stompClient.send("/pub/chat/send", {}, JSON.stringify(chatMessage));
        $("#msgInput").val(""); // 입력창 초기화
    }

    // 3. 과거 메시지 불러오기 (AJAX)
    function loadHistory() {
        $.get("/chat/history?room_id=" + roomId, function(data) {
            data.forEach(msg => {
                drawMessage(msg);
            });
        });
    }

    // 4. 화면에 메시지 그리기
    function drawMessage(msg) {
        const isMe = (msg.sender_id == myId);
        const boxClass = isMe ? "msg-box me" : "msg-box other";
        
        let html = "<div class='" + boxClass + "'>";
        html += "<div class='msg-content'>" + msg.message_text + "</div>";
        html += "</div>";

        $("#chatArea").append(html);
        
        // 스크롤 맨 아래로 이동
        const chatArea = document.getElementById("chatArea");
        chatArea.scrollTop = chatArea.scrollHeight;
    }
</script>

<%@ include file="../include/footer.jsp" %>