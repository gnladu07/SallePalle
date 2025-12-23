<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/header.jsp"%>
<div class="main-write">
    <div class="write-container">
        <h1 class="write-title">중고 상품 등록</h1>
        <p class="write-subtitle">누군가의 기억이 나에게 새로움이 되는 순간, 살래팔래</p>
        
        <form id="writeForm" action="/traBoard/write" method="post" enctype="multipart/form-data">
        
            <!-- 썸네일 이미지 -->
            <div class="write-field">
                <label class="write-label">상품 사진</label>
                <div class="write-image-upload">
                    <input type="file" 
                           name="thumbFile" 
                           id="thumbFile" 
                           accept="image/*" 
                           required 
                           style="display: none;">
                    <label for="thumbFile" class="write-image-label">
                        <div class="write-image-preview" id="imagePreview">
                            <svg viewBox="0 0 24 24" fill="#ccc">
                                <path d="M21 19V5c0-1.1-.9-2-2-2H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2zM8.5 13.5l2.5 3.01L14.5 12l4.5 6H5l3.5-4.5z"/>
                            </svg>
                            <p>사진 추가</p>
                        </div>
                    </label>
                </div>
            </div>

            <!-- 상품명 -->
            <div class="write-field">
                <label class="write-label">상품명</label>
                <input type="text" 
                       class="write-input" 
                       name="title" 
                       placeholder="상품명을 입력하세요" 
                       required>
            </div>

            <!-- 상품 설명 -->
            <div class="write-field">
                <label class="write-label">상품 설명</label>
                <textarea class="write-textarea" 
                          name="content" 
                          placeholder="상품에 대해 자세히 설명해주세요" 
                          rows="6" 
                          required></textarea>
            </div>
            <div class="gpt-box">
			    <h4>GPT로 판매글 다듬기</h4>
			
			    <textarea id="gptRawInput"
			              rows="3"
			              placeholder="예: 나 5년 정도 사용한 지포스5090GT 램16기가짜리 데스크탑 60만원에 팔고싶어"></textarea>
			
			    <button type="button" id="btnGptGenerate">
			        GPT로 문장 만들어보기
			    </button>
			
			    <div id="gptPreviewBox" style="display:none;">
			        <h5>미리보기</h5>
			        <textarea id="gptPreview" rows="6"></textarea>
			
			        <button type="button" id="btnApplyGpt">
			            이 문장 사용
			        </button>
			        <button type="button" id="btnRetryGpt">
			            다시 만들어보기
			        </button>
			    </div>
			</div>

            <!-- 가격 & 수량 -->
            <div class="write-field-row">
                <div class="write-field">
                    <label class="write-label">판매 가격</label>
                    <div class="write-input-with-unit">
                        <input type="number" 
                               class="write-input" 
                               name="price_point" 
                               placeholder="0" 
                               required>
                        <span class="write-input-unit">P</span>
                    </div>
                </div>

                <div class="write-field">
                    <label class="write-label">수량</label>
                    <input type="number" 
                           class="write-input" 
                           name="quantity" 
                           value="1" 
                           min="1" 
                           required>
                </div>
            </div>

            <!-- 마일리지 설정 -->
            <div class="write-field">
                <label class="write-label">마일리지 설정</label>
                <div class="write-input-with-unit">
                    <input type="number" 
                           class="write-input" 
                           name="max_mileage_use" 
                           placeholder="최대 마일리지 사용 금액">
                    <span class="write-input-unitM">M</span>
                </div>
                <label class="write-checkbox">
                    <input type="checkbox" name="allow_full_mileage" value="Y">
                    <span>마일리지 전액 결제 허용</span>
                </label>
            </div>

            <!-- 카테고리 -->
            <div class="write-field">
                <label class="write-label">상품 카테고리</label>
                <select class="write-select" name="item_ctg_id" required>
                    <option value="">카테고리를 선택하세요</option>
                    <c:forEach var="c" items="${itemCategoryList}">
                        <option value="${c.item_ctg_id}">${c.item_ctg_name}</option>
                    </c:forEach>
                </select>
            </div>

            <!-- 지역 -->
            <div class="write-field">
                <label class="write-label">거래 지역</label>
                <select class="write-select" name="toplct_id" required>
                    <option value="">지역을 선택하세요</option>
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

            <!-- 상세 주소 -->
            <div class="write-field">
                <label class="write-label">거래 상세 주소</label>
                <div class="write-input-row">
                    <input type="text"
                           class="write-input"
                           id="detailAddress"
                           name="detail_address"
                           value="${loginInfo.detail_address}"
                           placeholder="주소 검색 버튼을 눌러주세요"
                           readonly
                           required>
                    <button type="button" 
                            class="write-btn-search" 
                            id="btnAddressSearch">
                        주소 검색
                    </button>
                </div>
            </div>

            <!-- 등록 버튼 -->
            <button type="submit" class="write-submit-btn">상품 등록하기</button>
        </form>
    </div>
</div>

<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
$(function(){
    // 이미지 미리보기
    $("#thumbFile").on("change", function(e){
        const file = e.target.files[0];
        if(file){
            const reader = new FileReader();
            reader.onload = function(e){
                $("#imagePreview").html('<img src="' + e.target.result + '">');
            };
            reader.readAsDataURL(file);
        }
    });

    // 주소 검색
    $("#btnAddressSearch").on("click", function(){
        new daum.Postcode({
            oncomplete: function(data) {
                let addr = "";
                if (data.userSelectedType === "R") {
                    addr = data.roadAddress;
                } else {
                    addr = data.jibunAddress;
                }
                $("#detailAddress").val(addr);
            }
        }).open();
    });
    
    function callGPT(){
        $.ajax({
            url: "/traBoard/gpt/description",
            type: "POST",
            data: {
                content: $("#gptRawInput").val()
            },
            success: function(res){
                $("#gptPreview").val(res);
                $("#gptPreviewBox").show();
            }
        });
    }

    $("#btnGptGenerate").on("click", function(){
        if($("#gptRawInput").val().trim() === ""){
            alert("내용을 입력해주세요.");
            return;
        }
        callGPT();
    });

    $("#btnRetryGpt").on("click", function(){
        callGPT();
    });

    $("#btnApplyGpt").on("click", function(){
        $("textarea[name='content']").val($("#gptPreview").val());
        alert("상품 설명에 적용되었습니다.");
    });
});

</script>

<%@ include file="../include/footer.jsp"%>