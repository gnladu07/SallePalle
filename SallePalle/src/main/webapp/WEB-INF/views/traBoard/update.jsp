<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/header.jsp" %>
<div class="main-join">
	<div class="join-container">
	<form action="/traBoard/update" method="post" enctype="multipart/form-data">
	    <!-- CSRF 토큰 (중요) -->
	    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
	    <input type="hidden" name="trade_id" value="${detail.trade_id}">
	
	    <label>썸네일</label>
	    <input type="file" name="thumbFile">
	
	    <label>내용</label>
	    <textarea name="content">${detail.content}</textarea>
	
	    <label>가격</label>
	    <input type="number" name="price_point" value="${detail.price_point}">
	
	    <label>마일리지 사용 한도</label>
	    <input type="number" name="max_mileage_use" value="${detail.max_mileage_use}">
	
	    <label>거래 지역</label>
		<select name="toplct_id" id="toplct_id">
		    <option value="">지역 선택</option>
		    <c:forEach var="loc" items="${topLocationList}">
		        <option value="${loc.toplct_id}"
		            <c:if test="${loc.toplct_id eq detail.toplct_id}">
		                selected
		            </c:if>
		        >
		            ${loc.toplct_name}
		        </option>
		    </c:forEach>
		</select>
	
	    <label>상세 주소</label>
		<div>
		    <input type="text" id="detail_address"
		           name="detail_address"
		           value="${detail.detail_address}"
		           readonly>
		
		    <button type="button" id="btnSearchAddress">
		        주소 검색
		    </button>
		</div>
		
		<div>
		    <input type="text" id="extra_address"
		           placeholder="상세 주소 입력 (동/호수 등)">
		</div>
	
	    <button type="submit">수정 완료</button>
	</form>
	</div>
</div>
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
$(function(){
    console.log("update.jsp 로드 완료");

    $("input[type=file]").on("change", function(){
        console.log("썸네일 변경 감지 :", this.files[0]);
    });

    $("form").on("submit", function(){
        console.log("판매글 수정 요청 전송");
    });
});
$(function(){
    console.log("update.jsp 주소 검색 로드");

    $("#btnSearchAddress").on("click", function(){
        console.log("주소 검색 버튼 클릭");

        new daum.Postcode({
            oncomplete: function(data) {
                console.log("주소 검색 결과:", data);

                let baseAddr = data.roadAddress || data.jibunAddress;
                $("#detail_address").val(baseAddr);

                console.log("기본 주소 세팅:", baseAddr);
            }
        }).open();
    });

    /* 상세주소 추가 입력 시 병합 */
    $("#extra_address").on("blur", function(){
        let base = $("#detail_address").val();
        let extra = $(this).val();

        if(base && extra){
            let fullAddr = base + " " + extra;
            $("#detail_address").val(fullAddr);

            console.log("상세 주소 병합:", fullAddr);
        }
    });

    /* 전송 전 필수값 검증 */
    $("form").on("submit", function(){
        console.log("폼 전송 시작");

        if($("#toplct_id").val() === ""){
            alert("거래 지역을 선택하세요.");
            console.log("전송 차단: 지역 미선택");
            return false;
        }

        if($("#detail_address").val() === ""){
            alert("주소를 입력하세요.");
            console.log("전송 차단: 주소 없음");
            return false;
        }
    });
});
</script>	
<%@ include file="../include/footer.jsp" %>