<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/header.jsp" %>
<style>
    .history-container { max-width: 900px; margin: 60px auto; padding: 20px; }
    .history-title { font-size: 24px; font-weight: bold; margin-bottom: 20px; padding-bottom: 10px; border-bottom: 2px solid #333; }
    
    .history-table { width: 100%; border-collapse: collapse; text-align: center; }
    .history-table th { background: #f8f9fa; padding: 12px; border-bottom: 1px solid #ddd; font-weight: bold; color: #555; }
    .history-table td { padding: 15px 12px; border-bottom: 1px solid #eee; vertical-align: middle; }
    
    .item-info { display: flex; align-items: center; text-align: left; }
    .item-info img { width: 50px; height: 50px; border-radius: 8px; object-fit: cover; margin-right: 15px; border: 1px solid #ddd; }
    .item-title { font-weight: bold; color: #333; }
    
    .status-badge { padding: 4px 8px; border-radius: 4px; font-size: 12px; font-weight: bold; }
    .status-join { background: #e3f2fd; color: #1976d2; }
    .status-leave { background: #ffebee; color: #c62828; }
</style>

<div class="history-container">
    <div class="history-title">나의 채팅 기록 내역</div>
    
    <table class="history-table">
        <thead>
            <tr>
                <th>채팅방 생성일</th>
                <th>거래 품목</th>
                <th>대화 상대</th>
                <th>나눈 대화(건)</th>
                <th>내 상태</th>
                <th>비고</th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <%-- 1. 채팅 기록이 아예 없을 때 (리스트가 비어있거나 null일 경우) --%>
                <c:when test="${empty historyLog}">
                    <tr>
                        <td colspan="6" style="padding: 100px 0; text-align: center; color: #888; font-size: 16px;">
                            <div style="font-size: 48px; margin-bottom: 15px;">📭</div>
                            진행했던 채팅 기록이 없습니다.
                        </td>
                    </tr>
                </c:when>
                
                <%-- 2. 채팅 기록이 있을 때 (기존 출력 로직) --%>
                <c:otherwise>
                    <c:forEach var="log" items="${historyLog}">
                        <c:set var="isBuyer" value="${log.buyer_id == loginInfo.member_id}" />
                        <c:set var="partnerName" value="${isBuyer ? log.seller_nickname : log.buyer_nickname}" />
                        <c:set var="myStatus" value="${isBuyer ? log.buyer_status : log.seller_status}" />
                        
                        <tr>
                            <td><fmt:formatDate value="${log.created_at}" pattern="yyyy/MM/dd HH:mm"/></td>
                            <td>
                                <div class="item-info">
                                    <img src="/upload/${log.trade_thumb_img}" alt="상품">
                                    <span class="item-title">${log.trade_title}</span>
                                </div>
                            </td>
                            <td><b>${partnerName}</b> 님</td>
                            <td>${log.message_count}건</td>
                            <td>
                                <c:choose>
                                    <c:when test="${myStatus == 'J'}"><span class="status-badge status-join">참여중</span></c:when>
                                    <c:otherwise><span class="status-badge status-leave">나간 방</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:if test="${myStatus == 'J'}">
                                    <button onclick="location.href='/chat/chatRoom?room_id=${log.room_id}'" style="padding: 5px 10px; background:#FF6F61; color:white; border:none; border-radius:4px; cursor:pointer; font-size:12px;">방입장</button>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>
</div>

<%@ include file="../include/footer.jsp" %>