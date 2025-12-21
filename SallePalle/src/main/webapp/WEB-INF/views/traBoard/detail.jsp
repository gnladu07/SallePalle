<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/header.jsp" %>
	<div class="seller-box">
	    <img src="${detail.thumb_img}">
	    <div>${detail.seller_nickname}</div>
	    <div>${detail.email}</div>
	</div>
	
	<div class="item-box">
	    <img src="/upload/${detail.thumb_img}">
	    <h2>${detail.title}</h2>
	    <p>${detail.content}</p>
	    <strong>${detail.price_point} P</strong>
	</div>
	
	<button id="btnRecommend">
	    추천 (<span id="recCnt">${detail.recommend_cnt}</span>)
	</button>
	<c:if test="${not empty loginUserid && detail.status eq 'S'}">
	    <button id="btnBuy">구매하기</button>
	</c:if>
	
	<c:if test="${detail.status eq 'C'}">
	    <button disabled>판매가 완료된 물품입니다.</button>
	</c:if>
	
	<div class="other-items">
	    <c:forEach var="o" items="${otherList}">
	        <a href="/traBoard/detail?trade_id=${o.trade_id}">
	            <img src="/upload/${o.thumb_img}">
	            <div>${o.title}</div>
	        </a>
	    </c:forEach>
	</div>
	
	<div id="buyModalOverlay" class="modal-overlay" style="display:none;">
	    <div id="buyModal" class="modal-box">
	
	        <!-- 닫기 버튼 -->
	        <button class="modal-close" id="closeBuyModal">×</button>
	
	        <h3>구매 진행</h3>
	
	        <p>
	            <strong>${detail.title}</strong> 상품 구매를 진행합니다.
	        </p>
	
	        <!-- 결제 수단 선택 -->
	        <label>
	            <input type="checkbox" id="payPoint">
	            살래 포인트로 구매
	        </label><br>
	
	        <label>
	            <input type="checkbox" id="payMileage">
	            팔래 마일리지로 구매
	        </label>
	
	        <!-- 마일리지 옵션 -->
	        <div id="mileageOption" style="display:none; margin-left:20px; margin-top:10px;">
	            <label>
	                <input type="radio" name="mileageType" value="FULL">
	                전액 마일리지로 구매
	            </label><br>
	
	            <label>
	                <input type="radio" name="mileageType" value="DISCOUNT">
	                마일리지 할인 적용
	            </label><br>
	
	            <input type="number" id="useMileage" placeholder="사용 마일리지">
	
	            <p>
	                최종 포인트 결제:
	                <strong><span id="finalPoint">${detail.price_point}</span> P</strong>
	            </p>
	        </div>
	
	        <!-- 보유 자산 표시 -->
	        <div class="wallet-info">
	            보유 살래P:
	            <strong>
	                <fmt:formatNumber value="${loginInfo.wallet_balance}" /> P
	            </strong><br>
	
	            보유 마일리지:
	            <strong>
	                <fmt:formatNumber value="${loginInfo.wallet_mileage}" /> M
	            </strong>
	        </div>
	
	        <!-- 구매 확정 -->
	        <button id="confirmBuy" disabled>구매 확정</button>
	
	    </div>
	</div>
<script>
$(function(){
    console.log("detail.jsp 로딩 완료");

    $("#btnRecommend").on("click", function(){
        console.log("추천 버튼 클릭");

        $.ajax({
            url: "/traBoard/recommend",
            type: "POST",
            data: {
                trade_id: "${detail.trade_id}"
            },
            success: function(res){
                console.log("추천 응답값:", res);

                if(res === -1){
                	alert("로그인이 필요한 기능입니다.");
                    location.href =
                      "/member/login?redirect=/traBoard/detail?trade_id=${detail.trade_id}";
                }
                else if(res === -2){
                    alert("이미 추천한 상품입니다.");
                }
                else {
                    $("#recCnt").text(res);
                }
            },
            error: function(xhr){
                console.log("추천 Ajax 에러 상태:", xhr.status);
            }
        });
    });
    
    console.log("구매 스크립트 로딩");
    
 	// [추가] 닫기 버튼
    $("#btnBuy").on("click", function(){
        if("${detail.status}" !== "S"){
            alert("판매가 완료된 물품입니다.");
            return;
        }

        console.log("구매 버튼 클릭");
        $("#buyModalOverlay").fadeIn(200);
    });
 	
 	// [추가] 배경 클릭 시 닫기
    $("#buyModalOverlay").on("click", function(e){
        if(e.target.id === "buyModalOverlay"){
            closeBuyModal();
        }
    });

    // [추가] ESC 키로 닫기
	$(document).on("click", "#closeBuyModal", function(e){
	    e.stopPropagation();
	    closeBuyModal();
	});

    // [추가] 모달 닫기 공통 함수
    function closeBuyModal(){
        $("#buyModalOverlay").fadeOut(200);
        
        // 상태 초기화
        $("#payPoint, #payMileage").prop("checked", false);
        $("#mileageOption").hide();
        $("#confirmBuy").prop("disabled", true);
        $("#useMileage").val("");
        $("#finalPoint").text(${detail.price_point});
        $("#walletInfo strong").css({
            "opacity": "1",
            "font-weight": "normal"
        });
    }

    // 결제 수단 선택
    $("#payPoint").on("change", function(){
        console.log("포인트 구매 선택");
        $("#payMileage").prop("checked", false);
        $("#mileageOption").hide();
        $("#confirmBuy").prop("disabled", false);
        
        $("#walletInfo strong").css("opacity", "0.4");
        $("#walletInfo strong").first().css({
            "opacity": "1",
            "font-weight": "bold"
        });
    });

    $("#payMileage").on("change", function(){
        console.log("마일리지 구매 선택");
        $("#payPoint").prop("checked", false);
        $("#mileageOption").show();
        $("#confirmBuy").prop("disabled", true);
        
        $("#walletInfo strong").css("opacity", "0.4");
        $("#walletInfo strong").last().css({
            "opacity": "1",
            "font-weight": "bold"
        });
    });

    $("input[name=mileageType]").on("change", function(){
        console.log("마일리지 타입:", $(this).val());
        $("#confirmBuy").prop("disabled", false);
    });

    $("#useMileage").on("input", function(){
        var price = ${detail.price_point};
        var use = Number($(this).val());
        var finalPrice = price - use;
        
        console.log("마일리지 할인:", use, "최종 포인트:", finalPrice);
        $("#finalPoint").text(finalPrice);
    });

    $("#confirmBuy").on("click", function(){
        console.log("구매 확정 클릭");

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
                console.log("구매 결과:", res);
                
                if(res === "NOT_ENOUGH_POINT"){
                    alert("포인트가 부족합니다. 충전 후 이용해 주세요.");
                    location.href = "/fintech/chargePoint";
                    return;
                }
                
                if(res === "NOT_ENOUGH_MILEAGE"){
                    alert("마일리지가 부족합니다. 충전 후 이용해 주세요.");
                    location.href = "/fintech/chargePoint";
                    return;
                }
				
                if(res === "SUCCESS"){
                    console.log("구매 성공 → 세션 갱신 요청");

                    $.ajax({
                        url: "/member/refreshSession",
                        type: "POST",
                        success: function(r){
                            console.log("세션 갱신 결과:", r);

                            if(r === "OK"){
                                alert("구매가 완료되었습니다.");

                                // detail.jsp 유지 + 최신 세션 반영
                                location.replace(
                                  "/traBoard/detail?trade_id=${detail.trade_id}"
                                );
                            }
                        },
                        error: function(xhr){
                            console.log("세션 갱신 실패:", xhr.status);
                        }
                    });
                }
            },
            error: function(xhr){
                console.log("구매 에러:", xhr.status);
            }
        });
    });
    
    $("#btnBuy").on("click", function(){
        if("${detail.status}" !== "S"){
            alert("판매가 완료된 물품입니다.");
            return;
        }
        $("#buyModal").show();
    });
});
</script>
<%@ include file="../include/footer.jsp" %>