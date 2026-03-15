<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/header.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>

<style>
    .chat-room-wrapper { max-width: 600px; margin: 100px auto 30px; border: 1px solid #ddd; border-radius: 10px; overflow: hidden; display: flex; flex-direction: column; height: 700px; }
    .chat-header { background: #FF6F61; color: white; padding: 15px; font-weight: bold; text-align: center; position: relative; }
    .chat-header button { position: absolute; right: 15px; top: 12px; background: white; color: #FF6F61; border: none; padding: 5px 10px; border-radius: 5px; cursor: pointer; font-weight: bold; }
    
    .chat-messages { flex-grow: 1; padding: 15px; background: #f5f6fa; overflow-y: auto; }
    .msg-box { display: flex; margin-bottom: 15px; }
    .msg-box.me { flex-direction: row-reverse; }
    .msg-content { max-width: 70%; padding: 10px 15px; border-radius: 15px; font-size: 14px; line-height: 1.4; word-break: break-all; }
    .msg-box.me .msg-content { background: #FF6F61; color: white; border-top-right-radius: 2px; }
    .msg-box.other .msg-content { background: white; color: #333; border: 1px solid #ddd; border-top-left-radius: 2px; }
    
    /* 시스템 메시지 스타일 */
    .system-msg-container { text-align: center; margin: 20px 0; width: 100%; }
    .system-msg { background: rgba(0,0,0,0.05); padding: 5px 15px; border-radius: 20px; font-size: 12px; color: #666; display: inline-block; }
    
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
    const roomId = "${param.room_id}"; 
    const myId = "${loginInfo.member_id}";
    const myNickname = "${loginInfo.nickname}";

    $(document).ready(function() {
        connect(); 
        loadHistory(); 

        // [결제/송금하기] 버튼 이벤트 추가
        $("#btnPay").on("click", function() {
            swal({
                title: "송금 및 결제 확인",
                text: "해당 상품의 금액만큼 포인트가 차감됩니다.\n정말로 송금하시겠습니까?",
                icon: "warning",
                buttons: ["취소", "송금하기"],
            }).then((willPay) => {
                if (willPay) {
                    $.ajax({
                        url: "/chat/pay",
                        type: "POST",
                        data: {
                            room_id: roomId,
                            "${_csrf.parameterName}": "${_csrf.token}"
                        },
                        success: function(res) {
                            if (res === "OK") {
                                swal("결제 완료", "판매자에게 포인트 송금이 완료되었습니다.", "success");
                                $("#btnPay").hide(); // 결제 성공 시 버튼 숨김
                            } else if (res === "INSUFFICIENT_POINTS") {
                                swal("잔액 부족", "살래포인트가 부족합니다. 충전 후 이용해주세요.", "error");
                            } else if (res === "NOT_BUYER") {
                                swal("권한 없음", "구매자만 결제할 수 있습니다.", "error");
                            } else {
                                swal("오류", "결제 처리 중 문제가 발생했습니다.", "error");
                            }
                        },
                        error: function() {
                            swal("오류", "서버 통신 실패", "error");
                        }
                    });
                }
            });
        });
    });

    function connect() {
        const socket = new SockJS('/ws-stomp');
        stompClient = Stomp.over(socket);
        
        stompClient.connect({}, function (frame) {
            stompClient.subscribe('/sub/chat/room/' + roomId, function (message) {
                const recvMsg = JSON.parse(message.body);
                drawMessage(recvMsg);
            });
        });
    }

    function sendMsg() {
        const text = $("#msgInput").val().trim();
        if(text === "") return;

        const chatMessage = {
            room_id: roomId,
            sender_id: myId,
            message_text: text,
            sender_nickname: myNickname,
            type: "TEXT"
        };

        stompClient.send("/pub/chat/send", {}, JSON.stringify(chatMessage));
        $("#msgInput").val(""); 
    }

    function loadHistory() {
        $.get("/chat/history?room_id=" + roomId, function(data) {
            data.forEach(msg => {
                drawMessage(msg);
            });
        });
    }

    function drawMessage(msg) {
        const chatArea = $("#chatArea");
        let html = "";

        // 1. 시스템 메시지 처리 (결제 완료 등)
        if (msg.type === "SYSTEM") {
            html = "<div class='system-msg-container'>" +
                   "<span class='system-msg'>" + msg.message_text + "</span>" +
                   "</div>";
        } 
        // 2. 일반 메시지 처리
        else {
            const isMe = (msg.sender_id == myId);
            const boxClass = isMe ? "msg-box me" : "msg-box other";
            
            html = "<div class='" + boxClass + "'>" +
                   "<div class='msg-content'>" + msg.message_text + "</div>" +
                   "</div>";
        }

        chatArea.append(html);
        
        // 스크롤 맨 아래로 이동
        chatArea.scrollTop(chatArea[0].scrollHeight);
    }
</script>

<%@ include file="../include/footer.jsp" %>