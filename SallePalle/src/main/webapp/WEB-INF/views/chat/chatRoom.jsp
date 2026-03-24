<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/header.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>

<style>
    .chat-room-wrapper { max-width: 600px; margin: 100px auto 30px; border: 1px solid #ddd; border-radius: 10px; overflow: hidden; display: flex; flex-direction: column; height: 700px; }
    .chat-header { background: #FF6F61; color: white; padding: 15px; font-weight: bold; text-align: center; position: relative; }
    .chat-header button { position: absolute; right: 15px; top: 12px; background: white; color: #FF6F61; border: none; padding: 5px 10px; border-radius: 5px; cursor: pointer; font-weight: bold; }
    
    .chat-messages { flex-grow: 1; padding: 15px; background: #f5f6fa; overflow-y: auto; }
    
    /* 채팅 메시지 영역 스타일 개선 */
    .msg-box { display: flex; margin-bottom: 15px; width: 100%; }
    .msg-box.me { justify-content: flex-end; }
    .msg-box.other { justify-content: flex-start; }
    
    .msg-wrapper { display: flex; flex-direction: column; max-width: 70%; }
    .msg-box.other .msg-wrapper { align-items: flex-start; }
    .msg-box.me .msg-wrapper { align-items: flex-end; }
    
    /* ★ 새로 추가된 닉네임 스타일 ★ */
    .msg-nickname { font-size: 12px; color: #888; margin-bottom: 4px; padding-left: 4px; font-weight: 600; }
    
    .msg-content { padding: 10px 15px; border-radius: 15px; font-size: 14px; line-height: 1.4; word-break: break-all; }
    .msg-box.me .msg-content { background: #FF6F61; color: white; border-top-right-radius: 2px; }
    .msg-box.other .msg-content { background: white; color: #333; border: 1px solid #ddd; border-top-left-radius: 2px; }
    
    .system-msg-container { text-align: center; margin: 15px 0; }
    .system-msg { background: #eee; color: #555; padding: 5px 15px; border-radius: 15px; font-size: 12px; }
    
    /* 시스템 메시지 스타일 */
    .system-msg-container { text-align: center; margin: 20px 0; width: 100%; }
    .system-msg { background: rgba(0,0,0,0.05); padding: 5px 15px; border-radius: 20px; font-size: 12px; color: #666; display: inline-block; }
    
    .chat-input-area { display: flex; padding: 15px; background: white; border-top: 1px solid #ddd; }
    .chat-input-area input { flex-grow: 1; padding: 10px; border: 1px solid #ccc; border-radius: 5px; outline: none; }
    .chat-input-area button { margin-left: 10px; padding: 10px 20px; background: #333; color: white; border: none; border-radius: 5px; cursor: pointer; }
    .unread-mark { font-size: 12px; color: #FF6F61; font-weight: bold; margin-right: 5px; margin-bottom: 2px; }
</style>

<div class="chat-room-wrapper">
    <div class="chat-header">
        채팅방
        <button type="button" id="btnPay">결제/송금하기</button>
        
        <sec:authorize access="hasRole('ROLE_ADMIN')">
            <button type="button" id="btnAdminClose" style="background:#e74c3c; color:white; margin-right:5px; position:absolute; right:120px; top:12px; border:none; padding:5px 10px; border-radius:5px; font-weight:bold; cursor:pointer;">강제 해산 🚨</button>
        </sec:authorize>
    </div>

    <div class="chat-messages" id="chatArea">
        </div>

    <div class="chat-input-area">
        <input type="file" id="chatFileInput" style="display:none;" onchange="uploadChatFile()">
        
        <button type="button" style="background:#ddd; color:#333; margin-right:5px; padding: 10px 15px; flex-shrink: 0; border: none; border-radius: 5px; cursor: pointer;" onclick="$('#chatFileInput').click()">🔗</button>
        
        <input type="text" id="msgInput" placeholder="메시지를 입력하세요..." onkeypress="if(event.keyCode==13) sendMsg();">
        <button type="button" onclick="sendMsg()">전송</button>
    </div>
</div>

<script>
    let stompClient = null;
    const roomId = "${param.room_id}"; 
    const myId = "${loginInfo.member_id}";
    const myNickname = "${loginInfo.nickname}";
    
    function markAsRead() {
        $.ajax({
            url: "/chat/markAsRead",
            type: "POST",
            data: {
                room_id: roomId,
                "${_csrf.parameterName}": "${_csrf.token}"
            },
            success: function(res) {
                if(res === "OK") {
                    console.log("메시지 읽음 처리 완료");
                }
            }
        });
    }

    $(document).ready(function() {
        connect(); 
        loadHistory(); 
        markAsRead();
        
     	// [강제 해산] 버튼 이벤트
        $("#btnAdminClose").on("click", function() {
            swal({
                title: "채팅방 강제 해산",
                text: "이 채팅방을 즉시 폭파하고 모든 대화 내역을 삭제하시겠습니까?\n(참여자들은 메인화면으로 튕겨납니다)",
                icon: "warning",
                buttons: ["취소", "강제 해산"],
                dangerMode: true,
            }).then((willDelete) => {
                if (willDelete) {
                    $.ajax({
                        url: "/admin/chat/close",
                        type: "POST",
                        data: {
                            room_id: roomId,
                            "${_csrf.parameterName}": "${_csrf.token}"
                        },
                        success: function(res) {
                            if (res === "OK") {
                                swal("해산 완료", "채팅방이 강제로 폭파되었습니다.", "success")
                                .then(() => {
                                    window.close(); 
                                    location.href = "/admin/chatList"; 
                                });
                            }
                        }
                    });
                }
            });
        });

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
                                $("#btnPay").hide(); 
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
            stompClient.subscribe('/sub/chat/room/' + roomId, function(message) {
                const msg = JSON.parse(message.body);
                if (msg.type === "CLOSE") {
                    swal({
                        title: "강제 해산 🚨",
                        text: msg.message_text,
                        icon: "error",
                        button: "확인"
                    }).then(() => {
                        location.href = "/"; 
                    });
                    return;
                }
                
                if (msg.type === "READ") {
                    if (msg.sender_id != myId) {
                        $(".unread-mark").remove(); 
                    }
                    return;
                }
                
                drawMessage(msg); 
                
                if(msg.sender_id != myId) {
                    markAsRead();
                }
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
            type: "TEXT",
           	is_read: "N"
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

        // 1. 시스템 메시지 처리 (결제 완료, 나감 등)
        if (msg.type === "SYSTEM") {
            html = "<div class='system-msg-container'>" +
                   "<span class='system-msg'>" + msg.message_text + "</span>" +
                   "</div>";
        } 
        
     	// 2. 일반 텍스트, 사진, 파일 메시지 처리
        else {
            const isMe = (msg.sender_id == myId);
            const boxClass = isMe ? "msg-box me" : "msg-box other";
            
            html += "<div class='" + boxClass + "'>";
            
            let displayContent = msg.message_text;
            let contentStyle = ""; 
            if (msg.type === 'IMAGE') {
                displayContent = "<img src='/upload/" + msg.message_text + "' style='max-width: 200px; border-radius: 8px; cursor: pointer;' onclick='window.open(this.src)'/>";
                contentStyle = "background: transparent; padding: 0; border: none;"; // 사진은 말풍선 배경 없앰
            } else if (msg.type === 'FILE') {
                displayContent = "<a href='/upload/" + msg.message_text + "' download style='color: blue; text-decoration: underline; font-weight:bold;'>📁 파일 다운로드</a>";
            }
            
            // 내 메시지일 때
            if (isMe) {
                html += "<div class='msg-wrapper' style='display:flex; flex-direction:row; align-items:flex-end;'>";
                if (msg.is_read === 'N') {
                    html += "<span class='unread-mark'>1</span>";
                }
                html += "<div class='msg-content' style='" + contentStyle + "'>" + displayContent + "</div>";
                html += "</div>";
            } 
            
            // 상대방 메시지일 때
            else {
                html += "<div class='msg-wrapper'>";
                html += "<div class='msg-nickname'>" + msg.sender_nickname + "</div>";
                html += "<div style='display:flex; align-items:flex-end;'>";
                html += "<div class='msg-content' style='" + contentStyle + "'>" + displayContent + "</div>";
                html += "</div>";
                html += "</div>";
            }
            
            html += "</div>";
        }

        chatArea.append(html);
        chatArea.scrollTop(chatArea[0].scrollHeight);
    }
 	
	// 첨부파일 선택 시 팝업으로 확인 후 업로드 및 전송
    function uploadChatFile() {
        const fileInput = $("#chatFileInput")[0];
        if(fileInput.files.length === 0) return;

        const file = fileInput.files[0];
        const fileName = file.name;
        const fileSizeMB = (file.size / (1024 * 1024)).toFixed(2);

        swal({
            title: "파일 전송",
            text: "[" + fileName + "] (" + fileSizeMB + "MB)\n이 파일을 채팅방에 전송하시겠습니까?",
            icon: "info",
            buttons: ["취소", "전송하기"],
        }).then((willSend) => {
            
            if (willSend) {
                const formData = new FormData();
                formData.append("file", file);
                formData.append("${_csrf.parameterName}", "${_csrf.token}");

                $.ajax({
                    url: "/chat/upload",
                    type: "POST",
                    data: formData,
                    processData: false,
                    contentType: false,
                    success: function(savedFileName) {
                        if(savedFileName !== "FAIL") {
                            const ext = savedFileName.split('.').pop().toLowerCase();
                            const isImage = ['jpg', 'jpeg', 'png', 'gif', 'webp'].includes(ext);
                            const msgType = isImage ? "IMAGE" : "FILE";
                            const chatMessage = {
                                room_id: roomId,
                                sender_id: myId,
                                message_text: savedFileName,
                                sender_nickname: myNickname,
                                type: msgType, 
                                is_read: "N"
                            };

                            stompClient.send("/pub/chat/send", {}, JSON.stringify(chatMessage));
                        } else {
                            swal("오류", "파일 업로드에 실패했습니다.", "error");
                        }
                        $("#chatFileInput").val(""); 
                    }
                });
            } else {
                $("#chatFileInput").val("");
            }
        });
    }
</script>

<%@ include file="../include/footer.jsp" %>