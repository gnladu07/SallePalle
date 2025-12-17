<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/header.jsp" %>
<div class="main-saleTradeList">
    <div class="saleTradeList-container">
		<!-- 검색창 -->
		<form action="/traBoard/saleTradeList" method="get" class="saleTradeList-search-box">
		    
		    <!-- 검색 조건 선택 -->
		    <select name="type" class="saleTradeList-search-select">
		        <option value="title">제목</option>
		        <option value="content">내용</option>
		        <option value="seller">판매자</option>
		        <option value="item">물품종류</option>
		    </select>
		
		    <!-- 검색어 -->
		    <input type="text" name="keyword" placeholder="검색어 입력"
		           value="${param.keyword}">
		
		    <button type="submit" class="btn-search">검색</button>
		</form>

        <!-- 카테고리 탭 -->
        <div class="saleTradeList-category">
            <button class="saleTradeList-category-btn active">전체</button>
            <button class="saleTradeList-category-btn">도서</button>
            <button class="saleTradeList-category-btn">생활/가전</button>
            <button class="saleTradeList-category-btn">가구/인테리어</button>
            <button class="saleTradeList-category-btn">의류</button>
            <button class="saleTradeList-category-btn">가구</button>
            <button class="saleTradeList-category-btn">게임</button>
            <button class="saleTradeList-category-btn">스포츠</button>
            <button class="saleTradeList-category-btn">식료품</button>
            <button class="saleTradeList-category-btn">해외직구</button>
            <button class="saleTradeList-category-btn">PC용품</button>
            <button class="saleTradeList-category-btn">레저</button>
            <button class="saleTradeList-category-btn">기타</button>
        </div>

        <!-- 물품 그리드 -->
        <div class="saleTradeList-grid">
            <c:forEach var="s" items="${saleTradeList}">
                <a href="/sale/detail" class="saleTradeList-card">
                    <div class="saleTradeList-img">
                        <c:if test="${!empty s.thumb_img}">
                            <img src="/upload/${s.thumb_img}" alt="${s.title}">
                        </c:if>
                    </div>
                    <div class="saleTradeList-content">
                        <div class="saleTradeList-title">${s.title}</div>
                        <div class="saleTradeList-price">${s.price_point} P</div>
                        <div class="saleTradeList-info">
                            <span class="saleTradeList-location">
                                <svg viewBox="0 0 24 24" fill="#999">
                                    <path d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7zm0 9.5c-1.38 0-2.5-1.12-2.5-2.5s1.12-2.5 2.5-2.5 2.5 1.12 2.5 2.5-1.12 2.5-2.5 2.5z"/>
                                </svg>
                                ${s.toplct_name}
                            </span>
                            <span class="saleTradeList-likes">
                                <svg viewBox="0 0 24 24" fill="#FF6F61">
                                    <path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"/>
                                </svg>
                                ${s.recommend_cnt}
                            </span>
                        </div>
                        <div class="saleTradeList-meta">
                            <span class="saleTradeList-seller">${s.seller_nickname}</span>
                            <span class="saleTradeList-date">
                                <fmt:formatDate value="${s.regdate}" pattern="MM-dd"/>
                            </span>
                        </div>
                    </div>
                </a>
            </c:forEach>
        </div>

    </div>
</div>

<script>
$(function(){
    console.log("saleTradeList.jsp 로딩 완료");
    console.log("리스트 개수:", "${fn:length(saleTradeList)}");
});
</script>

<%@ include file="../include/footer.jsp" %>