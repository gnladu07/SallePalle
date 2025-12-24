<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/header.jsp"%>

 <div class="main-home">
    <div class="main-inner">

        <!-- 메인 타이틀 -->
        <h1 class="home-title">
            <svg viewBox="0 0 24 24" fill="#FF6F61" style="width:48px; height:48px; display:inline-block; vertical-align:middle; margin-right:8px;">
                <path d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7zm0 9.5c-1.38 0-2.5-1.12-2.5-2.5s1.12-2.5 2.5-2.5 2.5 1.12 2.5 2.5-1.12 2.5-2.5 2.5z"/>
            </svg>
            당신 근처의 살래팔래
        </h1>
        <p class="home-subtitle">누군가의 기억이 나에게 새로움이 되는 순간, 살래팔래</p>

        <!-- 통합 검색창 -->
        <div class="search-box">
            <form action="/traBoard/saleTradeList" method="get">
                <input type="hidden" name="type" value="title">
                <input type="text" name="keyword"
                       placeholder="찾고 싶은 물건을 검색해보세요">
                <button type="submit">검색</button>
            </form>
        </div>

        <!-- 카테고리 리스트 -->
        <div class="category-section">
            <div class="category">
                <c:forEach var="ctg" items="${itemCategoryList}">
                    <a href="/traBoard/saleTradeList?item_ctg_id=${ctg.item_ctg_id}">
                        ${ctg.item_ctg_name}
                    </a>
                </c:forEach>
            </div>
        </div>

        <!-- 최신 중고 거래 5개 -->
        <div class="fade-in-section">
            <div class="section-header">
                <h3 class="section-title">최신 중고 거래</h3>
                <p class="section-subtitle">방금 올라온 따끈따끈한 상품들을 만나보세요</p>
            </div>
            <div class="trade-grid">
                <c:forEach var="trade" items="${latestTradeList}">
                    <a href="/traBoard/detail?trade_id=${trade.trade_id}" class="trade-card">
                        <div class="trade-card-img">
                            <c:if test="${!empty trade.thumb_img}">
                                <img src="/upload/${trade.thumb_img}" alt="${trade.title}">
                            </c:if>
                        </div>
                        <div class="trade-card-content">
                            <div class="trade-card-title">${trade.title}</div>
                            <div class="trade-card-price">${trade.price_point} P</div>
                            <div class="trade-card-meta">
                                <span>${trade.toplct_name}</span>
                            </div>
                        </div>
                    </a>
                </c:forEach>
            </div>
        </div>

        <!-- 추천도 높은 순 5개 -->
        <div class="fade-in-section">
            <div class="section-header">
                <h3 class="section-title">추천 많은 거래</h3>
                <p class="section-subtitle">이웃들이 좋아하는 인기 상품을 확인해보세요</p>
            </div>
            <div class="trade-grid">
                <c:forEach var="trade" items="${recommendTradeList}">
                    <a href="/traBoard/detail?trade_id=${trade.trade_id}" class="trade-card">
                        <div class="trade-card-img">
                            <c:if test="${!empty trade.thumb_img}">
                                <img src="/upload/${trade.thumb_img}" alt="${trade.title}">
                            </c:if>
                        </div>
                        <div class="trade-card-content">
                            <div class="trade-card-title">${trade.title}</div>
                            <div class="trade-card-price">${trade.price_point} P</div>
                            <div class="trade-card-meta">
                                <span>${trade.toplct_name}</span>
                                <span class="trade-card-recommend">
                                    ❤️ ${trade.recommend_cnt}
                                </span>
                            </div>
                        </div>
                    </a>
                </c:forEach>
            </div>
        </div>

    </div>
</div>

<script>
$(function(){
    console.log("home.jsp 로딩 완료");
    
    // 스크롤 애니메이션
    const faders = document.querySelectorAll('.fade-in-section');
    
    const appearOptions = {
        threshold: 0.15,
        rootMargin: "0px 0px -100px 0px"
    };
    
    const appearOnScroll = new IntersectionObserver(function(entries, appearOnScroll) {
        entries.forEach(entry => {
            if (!entry.isIntersecting) {
                return;
            } else {
                entry.target.classList.add('is-visible');
                appearOnScroll.unobserve(entry.target);
            }
        });
    }, appearOptions);
    
    faders.forEach(fader => {
        appearOnScroll.observe(fader);
    });
});
</script>

<%@ include file="../include/footer.jsp"%>