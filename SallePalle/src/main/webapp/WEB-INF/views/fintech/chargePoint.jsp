<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/header.jsp"%>
<div class="main-charge">
	<div class="charge-container">   
	    <div class="charge-title">살래포인트 충전</div>
	    <p class="read-subtitle">지금 포인트 구입시 10%를 팔래마일리지로 적립!</p>
	
	    <!-- 포인트 리스트 -->
	    <form id="chargeForm" method="post" action="/fintech/chargeRequest">
	        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
	        <input type="hidden" id="amountInput" name="amount">
	
	        <div class="charge-item" data-amount="3000">
	            <div class="charge-left">
	                <img src="/resources/img/살래포인트.png">
	                <span>살래포인트 3000P</span>
	            </div>
	            <div class="charge-right">₩ 3,000</div>
	        </div>
	
	        <div class="charge-item" data-amount="5000">
	            <div class="charge-left">
	                <img src="/resources/img/살래포인트.png">
	                <span>살래포인트 5000P</span>
	            </div>
	            <div class="charge-right">₩ 5,000</div>
	        </div>
	
	        <div class="charge-item" data-amount="10000">
	            <div class="charge-left">
	                <img src="/resources/img/살래포인트.png">
	                <span>살래포인트 10000P</span>
	            </div>
	            <div class="charge-right">₩ 10,000</div>
	        </div>
	
	        <div class="charge-item" data-amount="30000">
	            <div class="charge-left">
	                <img src="/resources/img/살래포인트.png">
	                <span>살래포인트 30000P</span>
	            </div>
	            <div class="charge-right">₩ 30,000</div>
	        </div>
	
	        <div class="charge-item" data-amount="50000">
	            <div class="charge-left">
	                <img src="/resources/img/살래포인트.png">
	                <span>살래포인트 50000P</span>
	            </div>
	            <div class="charge-right">₩ 50,000</div>
	        </div>
	    </form>
	</div>
</div>

<script>
    $(function(){

        console.log("chargePoint.jsp 로딩됨");

        $(".charge-item").on("click", function(){

            const amount = $(this).data("amount");
            console.log("선택된 충전 금액:", amount);
            
         	// 확인 메시지
            const msg = amount + "포인트를 충전하시겠습니까?";
            if (!confirm(msg)) {
                console.log("사용자가 충전을 취소함");
                return;
            }

            $("#amountInput").val(amount);
            console.log("폼 amountInput 설정됨:", $("#amountInput").val());

            $("#chargeForm").submit();
        });

    });
</script>
<%@ include file="../include/footer.jsp"%>