<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/header.jsp" %>

<div class="main-write">
    <div class="write-container">
        <h1 class="write-title">중고 상품 재등록</h1>
        <p class="write-subtitle">상품 정보를 수정하여 다시 등록하세요</p>

        <form action="/traBoard/reupdate"
              method="post"
              enctype="multipart/form-data">

            <!-- PK -->
            <input type="hidden" name="trade_id" value="${trade.trade_id}">

            <!-- 기존 썸네일 유지용 -->
            <input type="hidden" name="thumb_img" value="${trade.thumb_img}">
            <input type="hidden" name="detail_img" value="${trade.detail_img}">

            <!-- 기존 썸네일 미리보기 -->
            <c:if test="${not empty trade.thumb_img}">
                <div class="write-field">
                    <label class="write-label">현재 상품 사진</label>
                    <div class="write-image-preview">
                        <img src="/upload/${trade.thumb_img}" alt="썸네일">
                    </div>
                </div>
            </c:if>

            <!-- 썸네일 수정 -->
            <div class="write-field">
                <label class="write-label">상품 사진 변경 (선택)</label>
                <div class="write-image-upload">
                    <input type="file"
                           name="thumbFile"
                           id="thumbFile"
                           accept="image/*"
                           style="display: none;">
                    <label for="thumbFile" class="write-image-label">
                        <div class="write-image-preview" id="imagePreview">
                            <svg viewBox="0 0 24 24" fill="#ccc">
                                <path d="M21 19V5c0-1.1-.9-2-2-2H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2zM8.5 13.5l2.5 3.01L14.5 12l4.5 6H5l3.5-4.5z"/>
                            </svg>
                            <p>새 사진 추가</p>
                        </div>
                    </label>
                </div>
                <small style="display:block; margin-top:8px; font-size:13px; color:#999;">※ 새 이미지를 선택하지 않으면 기존 썸네일 유지</small>
            </div>

            <!-- 상품명 -->
            <div class="write-field">
                <label class="write-label">상품명</label>
                <input type="text"
                       class="write-input"
                       name="title"
                       value="${trade.title}"
                       placeholder="상품명을 입력하세요"
                       required>
            </div>

            <!-- 내용 -->
            <div class="write-field">
                <label class="write-label">상품 설명</label>
                <textarea name="content"
                          class="write-textarea"
                          rows="6"
                          placeholder="상품에 대해 자세히 설명해주세요"
                          required>${trade.content}</textarea>
            </div>
            <div class="update-field">
			    <label class="update-label">GPT로 판매글 다듬기</label>
			
			    <textarea id="gptRawInput"
			              rows="6"
			              class="update-textarea"
			              placeholder="예: 나 5년 정도 사용한 지포스5090GT 램16기가짜리 데스크탑 60만원에 팔고싶어"
			              required></textarea>
			
			    <button type="button" id="btnGptGenerate" class="btn-gpt">
			        ✨ GPT로 문장 만들어보기
			    </button>
			
			    <div id="gptPreviewBox" class="write-field" style="display:none;">
			        <label class="write-label">미리보기</label>
			        <textarea id="gptPreview" class="write-textarea" rows="6"></textarea>
			
			        <div class="gpt-preview-buttons">
                        <button type="button" id="btnApplyGpt" class="btn-apply-gpt">
                            ✨ 문장 사용
                        </button>
                        <button type="button" id="btnRetryGpt" class="btn-retry-gpt">
                            🪄 다시 만들기
                        </button>
                    </div>
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
                               value="${trade.price_point}"
                               min="0"
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
                           value="${trade.quantity}"
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
                           value="${trade.max_mileage_use}"
                           min="0"
                           placeholder="최대 마일리지 사용 금액">
                    <span class="write-input-unitM">M</span>
                </div>
                <label class="write-checkbox">
                    <input type="checkbox" 
                           name="allow_full_mileage" 
                           value="Y"
                           <c:if test="${trade.allow_full_mileage eq 'Y'}">checked</c:if>>
                    <span>마일리지 전액 결제 허용</span>
                </label>
            </div>

            <!-- 카테고리 -->
            <div class="write-field">
                <label class="write-label">상품 카테고리</label>
                <select class="write-select" name="item_ctg_id" required>
                    <option value="">카테고리를 선택하세요</option>
                    <c:forEach var="ctg" items="${itemCategoryList}">
                        <option value="${ctg.item_ctg_id}"
                            <c:if test="${ctg.item_ctg_id eq trade.item_ctg_id}">selected</c:if>>
                            ${ctg.item_ctg_name}
                        </option>
                    </c:forEach>
                </select>
            </div>

            <!-- 등록 버튼 -->
            <button type="submit" class="write-submit-btn">
                재등록하기
            </button>
            <a href="/member/traList" 
               class="write-submit-btn" 
               style="width:671px; display:block; text-align:center; background:linear-gradient(135deg, #999, #666); text-decoration:none; margin-top:10px;">
                취소
            </a>

        </form>
    </div>
</div>

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

<%@ include file="../include/footer.jsp" %>