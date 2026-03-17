<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/header.jsp" %>
<style>
    .recent-container { max-width: 1000px; margin: 60px auto; padding: 20px; }
    .recent-title { font-size: 24px; font-weight: bold; margin-bottom: 20px; padding-bottom: 10px; border-bottom: 2px solid #333; }
    
    .item-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(220px, 1fr)); gap: 20px; }
    .item-card { border: 1px solid #eee; border-radius: 10px; overflow: hidden; transition: transform 0.2s; background: white; cursor: pointer; position: relative; }
    .item-card:hover { transform: translateY(-5px); box-shadow: 0 5px 15px rgba(0,0,0,0.1); }
    
    .item-img { width: 100%; height: 200px; object-fit: cover; }
    .item-info { padding: 15px; }
    .item-title { font-size: 16px; margin-bottom: 10px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
    .item-price { font-size: 18px; font-weight: bold; color: #FF6F61; }
    .view-time { font-size: 12px; color: #888; margin-top: 10px; display: block; text-align: right; }
    
    .status-badge { position: absolute; top: 10px; left: 10px; padding: 5px 10px; background: rgba(0,0,0,0.6); color: white; font-size: 12px; font-weight: bold; border-radius: 5px; }
    .status-C { background: rgba(200,0,0,0.8); } /* 거래완료 */
    
    .empty-msg { text-align: center; padding: 100px 0; color: #888; font-size: 16px; grid-column: 1 / -1; }
</style>

<div class="recent-container">
    <div class="recent-title">나의 최근 본 상품</div>
    
    <div class="item-grid">
        <c:choose>
            <%-- 최근 본 글이 없을 때 --%>
            <c:when test="${empty recentList}">
                <div class="empty-msg">
                    <div style="font-size: 48px; margin-bottom: 15px;">👀</div>
                    최근에 둘러본 상품이 없습니다.
                </div>
            </c:when>
            
            <%-- 최근 본 글이 있을 때 --%>
            <c:otherwise>
                <c:forEach var="item" items="${recentList}">
                    <div class="item-card" onclick="location.href='/saletrade/detail?trade_id=${item.trade_id}'">
                        <%-- 거래 상태 뱃지 (예약중이거나 완료일 때 띄움) --%>
                        <c:if test="${item.status == 'C'}"><div class="status-badge status-C">거래완료</div></c:if>
                        <c:if test="${item.status == 'R'}"><div class="status-badge">예약중</div></c:if>
                        
                        <img src="/upload/${item.thumb_img}" alt="상품 이미지" class="item-img" onerror="this.src='/resources/img/default_item.png'">
                        
                        <div class="item-info">
                            <div class="item-title">${item.title}</div>
                            <div class="item-price"><fmt:formatNumber value="${item.price_point}"/> P</div>
                            <span class="view-time">
                                <fmt:formatDate value="${item.viewed_at}" pattern="MM/dd HH:mm"/> 열람
                            </span>
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<%@ include file="../include/footer.jsp" %>