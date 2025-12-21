<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/header.jsp"%>
<div class="main-join">
	<div class="join-container">
        <h1 class="join-title">중고 상품 등록</h1>
        <p class="join-subtitle">누군가의 기억이 나에게 새로움이 되는 순간, 살래팔래</p>
        
		<form id="joinForm" action="/traBoard/write" method="post" enctype="multipart/form-data">
		
			<div class="join-field">
				<label class="join-label">상품명</label>
				<div class="join-input-row">				
			    	<input type="text" name="title" placeholder="상품명" required>
				</div>
			</div>		
			<div class="join-field">
				<label class="join-label">상품 설명</label>
				<div class="join-input-row">				
			    	<textarea name="content" placeholder="상품 설명" required></textarea>
				</div>
			</div>		
			<div class="join-field">
				<label class="join-label">상품 가격</label>
				<div class="join-input-row">				
			    	<input type="number" name="price_point" placeholder="판매 가격 (살래P)" required>
				</div>
			</div>		
			<div class="join-field">
				<label class="join-label">상품 개수</label>
				<div class="join-input-row">				
			    	<input type="number" name="quantity" value="1" min="1">
				</div>
			</div>		
			<div class="join-field">
				<label class="join-label">최대 사용 마일리지 설정</label>
				<div class="join-input-row">				
			    	<input type="number" name="max_mileage_use" placeholder="최대 마일리지 사용">
				</div>
			</div>		

		    <label>
		        <input type="checkbox" name="allow_full_mileage" value="Y">
		        마일리지 전액 결제 허용
		    </label>
		
		    <!-- 대표 지역 -->
			<div class="join-field">
			    <label class="join-label">대표 지역</label>
			    <div class="join-input-row">
			        <select name="toplct_id" required>
			            <c:forEach var="l" items="${topLocationList}">
			                <option value="${l.toplct_id}"
			                    <c:if test="${l.toplct_id == loginInfo.toplct_id}">
			                        selected
			                    </c:if>>
			                    ${l.toplct_name}
			                </option>
			            </c:forEach>
			        </select>
			    </div>
			</div>
		    
		    <!-- 거래 상세 주소 (카카오 주소찾기) -->
			<div class="join-field">
			    <label class="join-label">거래 상세 주소</label>
			    <div class="join-input-row">
			        <input type="text"
			               id="detailAddress"
			               name="detail_address"
			               value="${loginInfo.detail_address}"
			               placeholder="주소 검색 버튼을 눌러주세요"
			               readonly
			               required>
			
			        <button type="button"
			                id="btnAddressSearch"
			                style="margin-left:10px;">
			            주소 검색
			        </button>
			    </div>
			</div>
		    <!-- 상품 종류 -->
		    <select name="item_ctg_id" required>
		        <c:forEach var="c" items="${itemCategoryList}">
		            <option value="${c.item_ctg_id}">${c.item_ctg_name}</option>
		        </c:forEach>
		    </select>
		
		    <!-- 썸네일 -->
		    <input type="file" name="thumbFile" accept="image/*" required>
		
		    <button type="submit">상품 등록</button>
		</form>
	</div>
</div>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
$(function(){

    $("#btnAddressSearch").on("click", function(){

        new daum.Postcode({
            oncomplete: function(data) {

                /*
                 data.address        : 기본 주소
                 data.roadAddress    : 도로명 주소
                 data.jibunAddress   : 지번 주소
                */

                let addr = "";

                if (data.userSelectedType === "R") {
                    addr = data.roadAddress;   // 도로명
                } else {
                    addr = data.jibunAddress;  // 지번
                }

                // 주소 입력
                $("#detailAddress").val(addr);
            }
        }).open();
    });

});
</script>
<%@ include file="../include/footer.jsp"%>