<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/header.jsp" %>
<style>
    .chat-list-container { max-width: 800px; margin: 100px auto 40px; }
    .chat-room-item { display: flex; align-items: center; padding: 15px; border-bottom: 1px solid #eee; cursor: pointer; transition: background 0.2s; }
    .chat-room-item:hover { background: #f9f9f9; }
    .chat-thumb { width: 60px; height: 60px; border-radius: 8px; object-fit: cover; margin-right: 15px; }
    .chat-info { flex-grow: 1; }
    .chat-partner { font-weight: bold; font-size: 16px; margin-bottom: 5px; }
    .chat-last-msg { color: #666; font-size: 14px; }
    .chat-meta { display: flex; flex-direction: column; align-items: flex-end; font-size: 12px; color: #999; }
    .unread-badge { background: #FF6F61; color: white; border-radius: 50%; padding: 2px 8px; font-size: 12px; font-weight: bold; margin-top: 5px; display: inline-block; }
    
    /* 나가기 버튼 스타일 */
    .btn-leave { margin-top: 8px; padding: 4px 10px; background-color: #fff; border: 1px solid #ddd; border-radius: 4px; color: #888; font-size: 12px; cursor: pointer; transition: 0.2s; }
    .btn-leave:hover { border-color: #FF6F61; color: #FF6F61; }
</style>

<div class="chat-list-container">
    <h2>내 채팅 목록</h2>
    
    <c:if test="${empty roomList}">
        <p style="text-align:center; padding: 50px; color:#999;">진행 중인 채팅이 없습니다.</p>
    </c:if>

    <c:forEach var="room" items="${roomList}">
        <c:set var="partnerName" value="${room.buyer_id == loginInfo.member_id ? room.seller_nickname : room.buyer_nickname}" />
        
        <div class="chat-room-item" onclick="location.href='/chat/chatRoom?room_id=${room.room_id}'">
            <img src="/upload/${room.trade_thumb_img}" class="chat-thumb" alt="상품 썸네일">
            <div class="chat-info">
                <div class="chat-partner">${partnerName} 님과의 대화</div>
                <div class="chat-last-msg">${room.last_message != null ? room.last_message : '새로운 대화를 시작해보세요!'}</div>
            </div>
            <div class="chat-meta">
                <div><fmt:formatDate value="${room.last_message_time}" pattern="MM/dd HH:mm"/></div>
                <c:if test="${room.unread_count > 0}">
                    <div class="unread-badge">${room.unread_count}</div>
                </c:if>
                <button type="button" class="btn-leave" onclick="leaveRoom(event, ${room.room_id})">나가기</button>
            </div>
        </div>
    </c:forEach>
</div>

<script>
// 채팅방 나가기 함수
function leaveRoom(event, roomId) {
    event.stopPropagation();

    swal({
        title: "채팅방 나가기",
        text: "정말 채팅방을 나가시겠습니까?\n(나가면 대화 내역을 다시 볼 수 없습니다)",
        icon: "warning",
        buttons: ["취소", "나가기"],
        dangerMode: true,
    }).then((willLeave) => {
        if (willLeave) {
            $.ajax({
                url: "/chat/leave",
                type: "POST",
                data: {
                    room_id: roomId,
                    "${_csrf.parameterName}": "${_csrf.token}"
                },
                success: function(res) {
                    if(res === "OK") {
                        swal("완료", "채팅방에서 나갔습니다.", "success").then(() => {
                            location.reload();
                        });
                    } else {
                        swal("오류", "처리에 실패했습니다.", "error");
                    }
                }
            });
        }
    });
}
</script>

<%@ include file="../include/footer.jsp" %>