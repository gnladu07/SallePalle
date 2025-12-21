<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/header.jsp" %>
</head>
<body>

<div class="main-detail">
    <div class="detail-container">
        
        <!-- 상품 이미지 섹션 -->
        <div class="detail-image-section">
            <div class="detail-main-image">
                <img src="/upload/${detail.thumb_img}" alt="${detail.title}">
            </div>
        </div>

        <!-- 상품 정보 섹션 -->
        <div class="detail-info-section">
            <!-- 판매자 정보 -->
            <div class="detail-seller">
                <img src="/upload/${detail.profile_img}" 
                     alt="판매자" class="detail-seller-img">
                <div class="detail-seller-info">
                    <div class="detail-seller-name">${detail.seller_nickname}</div>
                    <div class="detail-seller-location">${detail.toplct_name}</div>
                </div>
            </div>

            <!-- 제목 & 정보 -->
            <h1 class="detail-title">${detail.title}</h1>
            
            <div class="detail-meta">
                <span>
                    <fmt:formatDate value="${detail.regdate}" pattern="yyyy-MM-dd HH:mm"/>
                </span>
            </div>

            <!-- 가격 -->
            <div class="detail-price">${detail.price_point} P</div>

            <!-- 상태 배지 -->
            <c:if test="${detail.status eq 'C'}">
                <div class="detail-status-badge sold">판매완료</div>
            </c:if>

            <!-- 설명 -->
            <div class="detail-description">
                <h3>상품 설명</h3>
                <p>${detail.content}</p>
            </div>

            <!-- 지도 -->
            <div class="detail-map-section">
                <h3>거래 희망 장소</h3>
                <div id="map" class="detail-map"></div>
                <p class="detail-address">${detail.detail_address}</p>
            </div>

            <!-- 액션 버튼 -->
            <div class="detail-actions">
                <button class="detail-btn-recommend" id="btnRecommend">
                    <svg viewBox="0 0 24 24" fill="currentColor">
                        <path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"/>
                    </svg>
                    <span id="recCnt">${detail.recommend_cnt}</span>
                </button>

                <c:if test="${not empty loginUserid && detail.status eq 'S'}">
                    <button class="detail-btn-buy" id="btnBuy">구매하기</button>
                </c:if>

                <c:if test="${detail.status eq 'C'}">
                    <button class="detail-btn-sold" disabled>판매완료</button>
                </c:if>
            </div>
        </div>

    </div>

    <!-- 다른 상품 -->
    <div class="detail-other-section">
        <h2>이 판매자의 다른 상품</h2>
        <div class="detail-other-grid">
            <c:forEach var="o" items="${otherList}">
                <a href="/traBoard/detail?trade_id=${o.trade_id}" class="detail-other-card">
                    <div class="detail-other-img">
                        <img src="/upload/${o.thumb_img}" alt="${o.title}">
                    </div>
                    <div class="detail-other-title">${o.title}</div>
                    <div class="detail-other-price">${o.price_point} P</div>
                </a>
            </c:forEach>
        </div>
    </div>
</div>

<!-- 구매 모달 -->
<div id="buyModalOverlay" class="detail-modal-overlay">
    <div class="detail-modal">
        <button class="detail-modal-close" id="closeBuyModal">×</button>
        
        <h2 class="detail-modal-title">구매하기</h2>
        
        <div class="detail-modal-product">
            <img src="/upload/${detail.thumb_img}" alt="${detail.title}">
            <div>
                <div class="detail-modal-product-title">${detail.title}</div>
                <div class="detail-modal-product-price">${detail.price_point} P</div>
            </div>
        </div>

        <!-- 결제 수단 -->
        <div class="detail-modal-payment">
            <h3>결제 수단 선택</h3>
            
            <label class="detail-modal-option">
                <input type="checkbox" id="payPoint">
                <span>살래 포인트로 구매</span>
            </label>

            <label class="detail-modal-option">
                <input type="checkbox" id="payMileage">
                <span>팔래 마일리지로 구매</span>
            </label>

            <!-- 마일리지 옵션 -->
            <div id="mileageOption" class="detail-modal-mileage">
                <label class="detail-modal-radio">
                    <input type="radio" name="mileageType" value="FULL">
                    <span>전액 마일리지로 구매</span>
                </label>

                <label class="detail-modal-radio">
                    <input type="radio" name="mileageType" value="DISCOUNT">
                    <span>마일리지 할인 적용</span>
                </label>

                <input type="number" id="useMileage" class="detail-modal-input" placeholder="사용 마일리지">

                <div class="detail-modal-final">
                    최종 포인트 결제: <strong><span id="finalPoint">${detail.price_point}</span> P</strong>
                </div>
            </div>
        </div>

        <!-- 보유 자산 -->
        <div class="detail-modal-wallet" id="walletInfo">
            <div>보유 살래P: <strong><fmt:formatNumber value="${loginInfo.wallet_balance}"/> P</strong></div>
            <div>보유 팔래M: <strong><fmt:formatNumber value="${loginInfo.wallet_mileage}"/> M</strong></div>
        </div>

        <!-- 구매 확정 -->
        <button class="detail-modal-btn" id="confirmBuy" disabled>구매 확정</button>
    </div>
</div>

<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=f741118517088ca2272cc9689f78f15e&libraries=services"></script>
<script>
$(function(){
    console.log("detail.jsp 로딩 완료");

    // 추천 버튼
    $("#btnRecommend").on("click", function(){
        $.ajax({
            url: "/traBoard/recommend",
            type: "POST",
            data: { trade_id: "${detail.trade_id}" },
            success: function(res){
                if(res === -1){
                    alert("로그인이 필요한 기능입니다.");
                    location.href = "/member/login?redirect=/traBoard/detail?trade_id=${detail.trade_id}";
                }
                else if(res === -2){
                    alert("이미 추천한 상품입니다.");
                }
                else {
                    $("#recCnt").text(res);
                }
            }
        });
    });

    // 구매 모달
    $("#btnBuy").on("click", function(){
        if("${detail.status}" !== "S"){
            alert("판매가 완료된 물품입니다.");
            return;
        }
        $("#buyModalOverlay").fadeIn(200);
    });

    $("#closeBuyModal, #buyModalOverlay").on("click", function(e){
        if(e.target.id === "closeBuyModal" || e.target.id === "buyModalOverlay"){
            closeBuyModal();
        }
    });

    function closeBuyModal(){
        $("#buyModalOverlay").fadeOut(200);
        $("#payPoint, #payMileage").prop("checked", false);
        $("#mileageOption").hide();
        $("#confirmBuy").prop("disabled", true);
        $("#useMileage").val("");
        $("#finalPoint").text(${detail.price_point});
        $("#walletInfo strong").css({"opacity": "1", "font-weight": "normal"});
    }

    // 결제 수단
    $("#payPoint").on("change", function(){
        $("#payMileage").prop("checked", false);
        $("#mileageOption").hide();
        $("#confirmBuy").prop("disabled", false);
        $("#walletInfo strong").css("opacity", "0.4");
        $("#walletInfo strong").first().css({"opacity": "1", "font-weight": "bold"});
    });

    $("#payMileage").on("change", function(){
        $("#payPoint").prop("checked", false);
        $("#mileageOption").show();
        $("#confirmBuy").prop("disabled", true);
        $("#walletInfo strong").css("opacity", "0.4");
        $("#walletInfo strong").last().css({"opacity": "1", "font-weight": "bold"});
    });

    $("input[name=mileageType]").on("change", function(){
        $("#confirmBuy").prop("disabled", false);
    });

    $("#useMileage").on("input", function(){
        var price = ${detail.price_point};
        var use = Number($(this).val());
        var finalPrice = price - use;
        $("#finalPoint").text(finalPrice);
    });

    // 구매 확정
    $("#confirmBuy").on("click", function(){
        $.ajax({
            url: "/traBoard/buy",
            type: "POST",
            data: {
                trade_id: "${detail.trade_id}",
                payPoint: $("#payPoint").is(":checked"),
                payMileage: $("#payMileage").is(":checked"),
                mileageType: $("input[name=mileageType]:checked").val(),
                useMileage: $("#useMileage").val()
            },
            success: function(res){
                if(res === "NOT_ENOUGH_POINT"){
                    alert("포인트가 부족합니다.");
                    return;
                }
                if(res === "NOT_ENOUGH_MILEAGE"){
                    alert("마일리지가 부족합니다.");
                    return;
                }
                if(res === "SUCCESS"){
                    $.ajax({
                        url: "/member/refreshSession",
                        type: "POST",
                        success: function(r){
                            if(r === "OK"){
                                alert("구매가 완료되었습니다.");
                                location.replace("/traBoard/detail?trade_id=${detail.trade_id}");
                            }
                        }
                    });
                }
            }
        });
    });

    // 카카오 지도
    var address = "${detail.detail_address}";
    if(address && address.trim() !== ""){
        var mapContainer = document.getElementById('map');
        var mapOption = {
            center: new kakao.maps.LatLng(37.5665, 126.9780),
            level: 3
        };
        var map = new kakao.maps.Map(mapContainer, mapOption);
        var geocoder = new kakao.maps.services.Geocoder();

        geocoder.addressSearch(address, function(result, status){
            if(status === kakao.maps.services.Status.OK){
                var coords = new kakao.maps.LatLng(result[0].y, result[0].x);
                var marker = new kakao.maps.Marker({ map: map, position: coords });
                var infowindow = new kakao.maps.InfoWindow({
                    content: '<div style="padding:6px 10px;">거래 위치<br><strong>' + address + '</strong></div>'
                });
                infowindow.open(map, marker);
                map.setCenter(coords);
            }
        });
    }
});
</script>

<%@ include file="../include/footer.jsp" %>