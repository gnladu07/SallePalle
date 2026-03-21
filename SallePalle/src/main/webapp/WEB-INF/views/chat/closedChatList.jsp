<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>강제 해산 채팅방 내역 - 관리자</title>
<style>
    body { font-family: 'Noto Sans KR', sans-serif; background: #f5f6fa; margin: 0; }
    .main-content { margin-left: 260px; padding: 40px; }
    .page-title { font-size: 24px; font-weight: bold; margin-bottom: 20px; color: #c0392b; }
    
    .admin-table { width: 100%; border-collapse: collapse; background: white; border-radius: 10px; overflow: hidden; box-shadow: 0 2px 10px rgba(0,0,0,0.05); }
    .admin-table th, .admin-table td { padding: 15px; text-align: left; border-bottom: 1px solid #eee; }
    .admin-table th { background: #2c3e50; color: white; font-weight: 500; }
    .admin-table tr:hover { background: #f9f9f9; }
    
    .btn-view { padding: 6px 12px; background: #7f8c8d; color: white; border: none; border-radius: 4px; cursor: pointer; text-decoration: none; font-size: 13px; }
    .btn-view:hover { background: #34495e; }
</style>
</head>
<body>

    <div class="main-content">
        <div class="page-title">🚫 강제 해산된 채팅방 (사기/규정 위반 증거)</div>
        
        <table class="admin-table">
            <thead>
                <tr>
                    <th>방 번호</th>
                    <th>거래 물품명</th>
                    <th>참여자 (구매자 ↔ 판매자)</th>
                    <th>마지막 캡처된 메시지</th>
                    <th>해산 시간 추정</th>
                    <th>증거 열람</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="room" items="${closedList}">
                    <tr>
                        <td style="color:#c0392b; font-weight:bold;">${room.room_id}</td>
                        <td>${room.trade_title}</td>
                        <td>${room.buyer_nickname} ↔ ${room.seller_nickname}</td>
                        <td style="max-width: 250px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; color: #7f8c8d;">
                            ${room.last_message}
                        </td>
                        <td><fmt:formatDate value="${room.last_message_time}" pattern="MM/dd HH:mm"/></td>
                        <td>
                            <a href="/chat/chatRoom?room_id=${room.room_id}" class="btn-view" target="_blank">내역 확인</a>
                        </td>
                    </tr>
                </c:forEach>
                
                <c:if test="${empty closedList}">
                    <tr>
                        <td colspan="6" style="text-align:center; padding: 30px; color:#888;">강제 해산된 채팅방 기록이 없습니다.</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>

</body>
</html>