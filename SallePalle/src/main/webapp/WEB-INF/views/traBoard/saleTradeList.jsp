<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/header.jsp" %>
<div class="main-saleTradeList">
    <div class="saleTradeList-container">
        <!-- 통합 검색창 -->
        <form action="/traBoard/saleTradeList" method="get" class="saleTradeList-search-box">
            <div class="saleTradeList-search-wrapper">
                <!-- 검색 조건 선택 -->
                <select name="type" class="saleTradeList-search-select">
                    <option value="all">전체</option>
                    <option value="title">제목</option>
                    <option value="content">내용</option>
                    <option value="seller">판매자</option>
                </select>

                <!-- 검색어 -->
                <input type="text" name="keyword" placeholder="검색어를 입력하세요"
                       value="${param.keyword}">

                <button type="submit" class="btn-search">검색</button>
            </div>
        </form>

        <!-- 카테고리 탭 -->
        <div class="saleTradeList-category">
            <button class="saleTradeList-category-btn
                ${empty item_ctg_id ? 'active' : ''}"
                data-item-id="">전체</button>

            <button class="saleTradeList-category-btn
                ${item_ctg_id == 1 ? 'active' : ''}"
                data-item-id="1">도서</button>

            <button class="saleTradeList-category-btn
                ${item_ctg_id == 2 ? 'active' : ''}"
                data-item-id="2">생활/가전</button>

            <button class="saleTradeList-category-btn
                ${item_ctg_id == 3 ? 'active' : ''}"
                data-item-id="3">가구/인테리어</button>

            <button class="saleTradeList-category-btn
                ${item_ctg_id == 4 ? 'active' : ''}"
                data-item-id="4">의류</button>

            <button class="saleTradeList-category-btn
                ${item_ctg_id == 5 ? 'active' : ''}"
                data-item-id="5">가구</button>

            <button class="saleTradeList-category-btn
                ${item_ctg_id == 6 ? 'active' : ''}"
                data-item-id="6">게임</button>

            <button class="saleTradeList-category-btn
                ${item_ctg_id == 7 ? 'active' : ''}"
                data-item-id="7">스포츠</button>

            <button class="saleTradeList-category-btn
                ${item_ctg_id == 8 ? 'active' : ''}"
                data-item-id="8">식료품</button>

            <button class="saleTradeList-category-btn
                ${item_ctg_id == 9 ? 'active' : ''}"
                data-item-id="9">해외직구</button>

            <button class="saleTradeList-category-btn
                ${item_ctg_id == 10 ? 'active' : ''}"
                data-item-id="10">PC용품</button>

            <button class="saleTradeList-category-btn
                ${item_ctg_id == 11 ? 'active' : ''}"
                data-item-id="11">레저</button>

            <button class="saleTradeList-category-btn
                ${item_ctg_id == 12 ? 'active' : ''}"
                data-item-id="12">기타</button>
        </div>

        <!-- 상품 등록 버튼 -->
        <c:if test="${loginInfo.seller_status eq 'Y'}">
            <div class="saleTradeList-register-section">
                <a href="/traBoard/write" class="btn-register-product">
                    <svg viewBox="0 0 24 24" fill="white">
                        <path d="M19 13h-6v6h-2v-6H5v-2h6V5h2v6h6v2z"/>
                    </svg>
                    상품 등록
                </a>
            </div>
        </c:if>

        <!-- 물품 그리드 -->
        <div class="saleTradeList-grid">
            <c:forEach var="s" items="${saleTradeList}">
                <a href="/traBoard/detail?trade_id=${s.trade_id}" class="saleTradeList-card">
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
    console.log("카테고리 필터 스크립트 로딩");

    $(".saleTradeList-category-btn").on("click", function () {
        var itemCtgId = $(this).data("item-id");
        console.log("선택한 item_ctg_id:", itemCtgId);

        var query = "";

        if(itemCtgId !== "" && itemCtgId !== undefined) {
            query = "?item_ctg_id=" + itemCtgId;
        }

        console.log("이동 URL:", "/traBoard/saleTradeList" + query);

        location.href = "/traBoard/saleTradeList" + query;
    });

});
</script>

<%@ include file="../include/footer.jsp" %>