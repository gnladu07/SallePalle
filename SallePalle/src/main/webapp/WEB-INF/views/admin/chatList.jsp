<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>채팅 모니터링 - 관리자</title>
<style>
    /* 기본 레이아웃 스타일 */
    body { font-family: 'Noto Sans KR', sans-serif; background: #f5f6fa; margin: 0; }
    .main-content { margin-left: 260px; padding: 40px; }
    .page-title { font-size: 24px; font-weight: bold; margin-bottom: 20px; color: #333; }
    
    /* 테이블 스타일 */
    .admin-table { width: 100%; border-collapse: collapse; background: white; border-radius: 10px; overflow: hidden; box-shadow: 0 2px 10px rgba(0,0,0,0.05); }
    .admin-table th, .admin-table td { padding: 15px; text-align: left; border-bottom: 1px solid #eee; }
    .admin-table th { background: #333; color: white; font-weight: 500; }
    .admin-table tr:hover { background: #f9f9f9; }
    
    /* 위험 감지 행 강조 스타일 */
    .flagged-row { background: #fff0f0 !important; }
    .flagged-row td { color: #d32f2f; font-weight: bold; }
    .badge { padding: 4px 8px; border-radius: 4px; font-size: 12px; font-weight: bold; }
    .badge-danger { background: #e74c3c; color: white; }
    .badge-safe { background: #2ecc71; color: white; }
    .badge-closed { background: #7f8c8d; color: white; }
    
    .closed-row { background: #f0f0f0 !important; }
    .closed-row td { color: #888; }
    
    .btn-view { padding: 6px 12px; background: #3498db; color: white; border: none; border-radius: 4px; cursor: pointer; text-decoration: none; font-size: 13px; }
    .btn-view:hover { background: #2980b9; }
</style>
</head>
<body>

    <div class="main-content">
        <div class="page-title">🚨 실시간 채팅 모니터링</div>
        
        <table class="admin-table">
            <thead>
                <tr>
                    <th>방 번호</th>
                    <th>상태</th>
                    <th>거래 물품명</th>
                    <th>참여자 (구매자 ↔ 판매자)</th>
                    <th>마지막 메시지</th>
                    <th>시간</th>
                    <th>관리</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="room" items="${chatList}">
                    <tr class="${room.admin_closed == 'Y' ? 'closed-row' : (room.is_flagged == 'Y' ? 'flagged-row' : '')}">
                        <td>${room.room_id}</td>
                        <td>
                            <c:choose>
                                <%-- 1순위: 이미 강제 해산된 방인지 체크 --%>
                                <c:when test="${room.admin_closed == 'Y'}">
                                    <span class="badge badge-closed">해산 완료</span>
                                </c:when>
                                <%-- 2순위: 해산 안 됐지만, GPT가 위험을 감지한 방인지 체크 --%>
                                <c:when test="${room.is_flagged == 'Y'}">
                                    <span class="badge badge-danger">위험 감지</span>
                                </c:when>
                                <%-- 3순위: 아무 문제 없는 깨끗한 방 --%>
                                <c:otherwise>
                                    <span class="badge badge-safe">정상</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>${room.trade_title}</td>
                        <td>${room.buyer_nickname} ↔ ${room.seller_nickname}</td>
                        <td style="max-width: 200px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
                            ${room.last_message}
                        </td>
                        <td><fmt:formatDate value="${room.last_message_time}" pattern="MM/dd HH:mm"/></td>
                        <td>
                            <a href="/chat/chatRoom?room_id=${room.room_id}" class="btn-view" target="_blank">열람하기</a>
                        </td>
                    </tr>
                </c:forEach>
                
                <c:if test="${empty chatList}">
                    <tr>
                        <td colspan="7" style="text-align:center; padding: 30px;">개설된 채팅방이 없습니다.</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>

</body>
</html>