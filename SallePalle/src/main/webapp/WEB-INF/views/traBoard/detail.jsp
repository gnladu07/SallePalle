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
	
	<div class="other-items">
	    <c:forEach var="o" items="${otherList}">
	        <a href="/traBoard/detail?trade_id=${o.trade_id}">
	            <img src="/upload/${o.thumb_img}">
	            <div>${o.title}</div>
	        </a>
	    </c:forEach>
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
});
</script>
<%@ include file="../include/footer.jsp" %>