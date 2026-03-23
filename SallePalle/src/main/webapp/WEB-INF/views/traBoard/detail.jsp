<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/header.jsp" %>

<style>
    /* 토글 스위치 전용 디자인 */
    .switch {
        position: relative;
        display: inline-block;
        width: 50px;
        height: 26px;
    }
    .switch input {
        opacity: 0;
        width: 0;
        height: 0;
    }
    .slider {
        position: absolute;
        cursor: pointer;
        top: 0; left: 0; right: 0; bottom: 0;
        background-color: #ccc;
        transition: .4s;
        border-radius: 34px;
    }
    .slider:before {
        position: absolute;
        content: "";
        height: 18px; width: 18px;
        left: 4px; bottom: 4px;
        background-color: white;
        transition: .4s;
        border-radius: 50%;
    }
    input:checked + .slider {
        background-color: #FF6F61;
    }
    input:checked + .slider:before {
        transform: translateX(24px);
    }
</style>

<div class="main-detail">
    <div class="detail-container">
        
        <div class="detail-image-section">
        	<h1 class="detail-title">${detail.title}</h1>
            <div class="detail-meta">
                <span>
                    <fmt:formatDate value="${detail.regdate}" pattern="yyyy-MM-dd HH:mm"/>
                </span>
                <span class="detail-category">
			        ${detail.item_ctg_name}
			    </span>
            </div>
            <div class="detail-main-image">
                <img src="/upload/${detail.thumb_img}" alt="${detail.title}">
            </div>
            <div class="detail-seller">
                <img src="/upload/${detail.profile_img}" 
                     alt="판매자" class="detail-seller-img">
                <div class="detail-seller-info">
                    <div class="detail-seller-name">${detail.seller_nickname}</div>
                    <div class="detail-seller-location">${detail.toplct_name}</div>
                </div>
            </div>
        </div>

        <div class="detail-info-section">

            <c:if test="${loginInfo.member_id == detail.seller_id && detail.status != 'C'}">
                <div class="toggle-container" style="display: flex; align-items: center; gap: 10px; margin-bottom: 20px; padding: 15px; background: #f8f9fa; border-radius: 12px;">
                    <span style="font-size: 14px; font-weight: 600; color: #666;">상품 상태 설정</span>
                    <label class="switch">
                        <input type="checkbox" id="statusToggle" ${detail.status == 'S' ? 'checked' : ''}>
                        <span class="slider"></span>
                    </label>
                    <span id="statusText" style="font-size: 15px; font-weight: bold; color: ${detail.status == 'S' ? '#FF6F61' : '#999'};">
                        ${detail.status == 'S' ? '판매중' : '판매중지'}
                    </span>
                </div>
            </c:if>

            <div class="detail-pricezon">            
	            <div class="detail-price" style="color: #FF6F61;">
	            	<p style="font-size: 20px; color: black;">희망 판매가:</p>
	            	<fmt:formatNumber value="${detail.price_point}" /> P
	            </div>
	            <div class="detail-mileage" style="color: #9B59B6;">
	            	<p style="font-size: 20px; color: black;">할인 가능 마일리지:</p>
	            	<fmt:formatNumber value="${empty detail.max_mileage_use ? 0 : detail.max_mileage_use}" /> M
	            </div>
            </div>

            <c:if test="${detail.status eq 'C'}">
                <div class="detail-status-badge sold">판매완료</div>
            </c:if>

            <div class="detail-description">
                <h3>상품 설명</h3>
                <p>${detail.content}</p>
            </div>

            <div class="detail-map-section">
                <h3>거래 희망 장소</h3>
                <div id="map" class="detail-map"></div>
                <p class="detail-address">${detail.detail_address}</p>
            </div>

			<div class="detail-actions">
                <button class="detail-btn-recommend" id="btnRecommend">
                    <svg viewBox="0 0 24 24" fill="currentColor">
                        <path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 
                                 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 
                                 4.5 2.09C13.09 3.81 14.76 3 16.5 3 
                                 19.58 3 22 5.42 22 8.5c0 3.78-3.4 
                                 6.86-8.55 11.54L12 21.35z"/>
                    </svg>
                    <span id="recCnt">${detail.recommend_cnt}</span>
                </button>

                <c:choose>
                    <c:when test="${detail.status eq 'C'}">
                        <button class="detail-btn-sold" disabled>판매완료</button>
                    </c:when>
                
                    <c:when test="${not empty loginUserid && loginUserid eq detail.seller_userid}">
                        <button class="detail-btn-edit"
                                onclick="location.href='/traBoard/update?trade_id=${detail.trade_id}'">
                            수정
                        </button>
                        <button type="button"
                                id="btnDeleteTrade"
                                class="detail-btn-delete"
                                data-trade-id="${detail.trade_id}">
                            삭제
                        </button>
                    </c:when>
                    
                    <c:when test="${detail.status eq 'R'}">
                        <button class="detail-btn-sold" disabled>판매중지된 상품입니다</button>
                    </c:when>
                
                    <c:when test="${empty loginUserid && detail.status eq 'S'}">
                        <button class="detail-btn-login" onclick="goLogin()">
                            로그인시 구매 가능합니다.
                        </button>
                    </c:when>
                
                    <c:otherwise>
                        <button type="button" class="detail-btn-buy" id="btnChatRoom" 
                                data-trade-id="${detail.trade_id}" 
                                data-seller-id="${detail.seller_id}">
                            채팅으로 거래하기
                        </button>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

    </div>

    <div class="detail-other-section">
        <h2>이 판매자의 다른 상품</h2>
        <div class="detail-other-grid">
            <c:forEach var="o" items="${otherList}">
                <a href="/traBoard/detail?trade_id=${o.trade_id}" class="detail-other-card">
                    <div class="detail-other-img">
                        <img src="/upload/${o.thumb_img}" alt="${o.title}">
                    </div>
                    <div class="detail-other-title">${o.title}</div>
                    <div class="detail-other-price"><fmt:formatNumber value="${o.price_point}" /> P</div>
                </a>
            </c:forEach>
        </div>
    </div>
</div>

<div id="buyModalOverlay" class="detail-modal-overlay">
    <div class="detail-modal">
        <button class="detail-modal-close" id="closeBuyModal">×</button>
        
        <h2 class="detail-modal-title">구매하기</h2>
        
        <div class="detail-modal-product">
            <img src="/upload/${detail.thumb_img}" alt="${detail.title}">
            <div>
                <div class="detail-modal-product-title">${detail.title}</div>
                <div class="detail-modal-product-price"><fmt:formatNumber value="${detail.price_point}" /> P</div>
            </div>
        </div>

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
                    최종 포인트 결제: <strong><span id="finalPoint"><fmt:formatNumber value="${detail.price_point}" /></span> P</strong>
                </div>
            </div>
        </div>

        <div class="detail-modal-wallet" id="walletInfo">
            <div>보유 살래P: <strong><fmt:formatNumber value="${loginInfo.wallet_balance}"/> P</strong></div>
            <div>보유 팔래M: <strong><fmt:formatNumber value="${loginInfo.wallet_mileage}"/> M</strong></div>
        </div>

        <button class="detail-modal-btn" id="confirmBuy" disabled>구매 확정</button>
    </div>
</div>
<form id="deleteTradeForm"
      action="/traBoard/delete"
      method="post">

    <input type="hidden" name="trade_id">

    <input type="hidden"
           name="${_csrf.parameterName}"
           value="${_csrf.token}">
</form>

<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=f741118517088ca2272cc9689f78f15e&libraries=services"></script>
<script>
$(function(){
    console.log("detail.jsp 로딩 완료");

    var tradePrice = ${detail.price_point};
    var myMileage = ${not empty loginInfo.wallet_mileage ? loginInfo.wallet_mileage : 0};
    var myBalance = ${not empty loginInfo.wallet_balance ? loginInfo.wallet_balance : 0};
    var myMemberId = "${loginInfo.member_id}";

    // 1. 카카오 지도
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

    // 2. 추천 버튼
    $("#btnRecommend").on("click", function(){
        $.ajax({
            url: "/traBoard/recommend",
            type: "POST",
            data: { 
                trade_id: "${detail.trade_id}",
                "${_csrf.parameterName}": "${_csrf.token}"
            },
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

    // 3. 구매 모달 및 결제 로직
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
        $("#finalPoint").text(tradePrice.toLocaleString());
        $("#walletInfo strong").css({"opacity": "1", "font-weight": "normal"});
    }

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
        var maxUsable = Math.min(tradePrice, myMileage);
        var use = Number($(this).val());

        if(use > maxUsable){
            alert("사용 가능한 마일리지를 초과했습니다.");
            $(this).val(maxUsable);
            use = maxUsable;
        }

        if(use < 0){
            $(this).val(0);
            use = 0;
        }

        var finalPrice = tradePrice - use;
        $("#finalPoint").text(finalPrice.toLocaleString());
    });

    $("#confirmBuy").on("click", function(){
        $.ajax({
            url: "/traBoard/buy",
            type: "POST",
            data: {
                trade_id: "${detail.trade_id}",
                payPoint: $("#payPoint").is(":checked"),
                payMileage: $("#payMileage").is(":checked"),
                mileageType: $("input[name=mileageType]:checked").val(),
                useMileage: $("#useMileage").val(),
                "${_csrf.parameterName}": "${_csrf.token}"
            },
            success: function(res){
                if(res === "NOT_ENOUGH_POINT") alert("포인트가 부족합니다.");
                else if(res === "NOT_ENOUGH_MILEAGE") alert("마일리지가 부족합니다.");
                else if(res === "SUCCESS"){
                    $.ajax({
                        url: "/member/refreshSession",
                        type: "POST",
                        data: { "${_csrf.parameterName}": "${_csrf.token}" },
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

    // 4. 삭제 로직
    $("#btnDeleteTrade").on("click", function(){
        let tradeId = $(this).data("trade-id");
        if(!confirm("정말 삭제하시겠습니까?")) return;
        $("#deleteTradeForm input[name='trade_id']").val(tradeId);
        $("#deleteTradeForm").submit();
    });

    // 5. 채팅방 생성 로직
    $("#btnChatRoom").on("click", function(){
        let tradeId = $(this).data("trade-id");
        let sellerId = $(this).data("seller-id");
        
        if(!myMemberId) {
            alert("로그인이 필요합니다.");
            location.href = "/member/login";
            return;
        }

        if(myMemberId == sellerId) {
            alert("본인이 등록한 물품입니다.");
            return;
        }

        $.ajax({
            url: "/chat/createRoom",
            type: "POST",
            data: {
                trade_id: tradeId,
                seller_id: sellerId,
                "${_csrf.parameterName}": "${_csrf.token}"
            },
            success: function(roomId){
                if(roomId === -1) {
                    alert("로그인이 필요합니다.");
                    location.href = "/member/login";
                } else {
                    location.href = "/chat/chatRoom?room_id=" + roomId;
                }
            },
            error: function(){
                alert("채팅방 연결에 실패했습니다.");
            }
        });
    });

    // 6. ★ 판매 상태 변경 토글 스위치 로직
    $("#statusToggle").change(function() {
        let isChecked = $(this).is(":checked");
        let newStatus = isChecked ? 'S' : 'R'; // S: 판매중, R: 판매중지
        let tradeId = ${detail.trade_id};

        $.ajax({
            url: "/traBoard/updateStatus",
            type: "POST",
            data: {
                trade_id: tradeId,
                status: newStatus,
                "${_csrf.parameterName}": "${_csrf.token}"
            },
            success: function(res) {
                if(res === "success") {
                    if(isChecked) {
                        $("#statusText").text("판매중").css("color", "#FF6F61");
                    } else {
                        $("#statusText").text("판매중지").css("color", "#999");
                    }
                } else {
                    alert("상태 변경에 실패했습니다.");
                    $("#statusToggle").prop("checked", !isChecked); // 실패 시 스위치 원상복구
                }
            },
            error: function() {
                alert("서버와 통신 중 오류가 발생했습니다.");
                $("#statusToggle").prop("checked", !isChecked); // 실패 시 스위치 원상복구
            }
        });
    });
});
</script>

<%@ include file="../include/footer.jsp" %>