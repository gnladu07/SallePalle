<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/header.jsp" %>
<style>
    .chat-list-container { max-width: 800px; margin: 40px auto; }
    .chat-room-item { display: flex; align-items: center; padding: 15px; border-bottom: 1px solid #eee; cursor: pointer; transition: background 0.2s; }
    .chat-room-item:hover { background: #f9f9f9; }
    .chat-thumb { width: 60px; height: 60px; border-radius: 8px; object-fit: cover; margin-right: 15px; }
    .chat-info { flex-grow: 1; }
    .chat-partner { font-weight: bold; font-size: 16px; margin-bottom: 5px; }
    .chat-last-msg { color: #666; font-size: 14px; }
    .chat-meta { text-align: right; font-size: 12px; color: #999; }
    .unread-badge { background: #FF6F61; color: white; border-radius: 50%; padding: 2px 8px; font-size: 12px; font-weight: bold; margin-top: 5px; display: inline-block; }
</style>

<div class="chat-list-container">
    <h2>내 채팅 목록</h2>
    <!-- test -->
    <c:if test="${empty roomList}">
        <p style="text-align:center; padding: 50px; color:#999;">진행 중인 채팅이 없습니다.</p>
    </c:if>

    <c:forEach var="room" items="${roomList}">
        <c:set var="partnerName" value="${room.buyer_id == loginInfo.member_id ? room.seller_nickname : room.buyer_nickname}" />
        
        <div class="chat-room-item" onclick="location.href='/chat/room?room_id=${room.room_id}'">
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
            </div>
        </div>
    </c:forEach>
</div>

<%@ include file="../include/footer.jsp" %>