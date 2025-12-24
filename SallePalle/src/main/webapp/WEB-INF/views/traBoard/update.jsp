<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/header.jsp" %>
<div class="main-update">
    <div class="update-container">
        <h1 class="update-title">상품 정보 수정</h1>
        <p class="update-subtitle">상품 정보를 수정하고 저장하세요</p>
        
        <form action="/traBoard/update" method="post" enctype="multipart/form-data">
            <!-- CSRF 토큰 -->
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
            <input type="hidden" name="trade_id" value="${detail.trade_id}">

            <!-- 현재 썸네일 이미지 -->
            <div class="update-field">
                <label class="update-label">상품 사진</label>
                <div class="update-image-current">
                    <img src="/upload/${detail.thumb_img}" alt="현재 상품 사진">
                </div>
                <div class="update-image-upload">
                    <input type="file" 
                           name="thumbFile" 
                           id="thumbFile" 
                           accept="image/*" 
                           style="display: none;">
                    <label for="thumbFile" class="update-image-label">
                        <svg viewBox="0 0 24 24" fill="#FF6F61">
                            <path d="M21 19V5c0-1.1-.9-2-2-2H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2zM8.5 13.5l2.5 3.01L14.5 12l4.5 6H5l3.5-4.5z"/>
                        </svg>
                        사진 변경하기
                    </label>
                </div>
                <div class="update-image-preview" id="imagePreview" style="display:none;">
                    <img src="" alt="새 이미지 미리보기">
                </div>
            </div>

            <!-- 상품명 (수정 불가) -->
            <div class="update-field">
                <label class="update-label">상품명</label>
                <input type="text" 
                       class="update-input update-input-disabled" 
                       value="${detail.title}" 
                       disabled>
                <div class="update-field-notice">상품명은 변경할 수 없습니다</div>
            </div>

            <!-- 상품 설명 -->
            <div class="update-field">
                <label class="update-label">상품 설명</label>
                <textarea class="update-textarea" 
                          name="content" 
                          rows="6" 
                          required>${detail.content}</textarea>
            </div>
            <div class="update-field">
			    <label class="update-label">GPT로 판매글 다듬기</label>
			
			    <textarea id="gptRawInput"
			              rows="6"
			              class="update-textarea"
			              placeholder="예: 나 5년 정도 사용한 지포스5090GT 램16기가짜리 데스크탑 60만원에 팔고싶어"></textarea>
			
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

            <!-- 가격 -->
            <div class="update-field">
                <label class="update-label">판매 가격</label>
                <div class="update-input-with-unit">
                    <input type="number" 
                           class="update-input" 
                           name="price_point" 
                           value="${detail.price_point}" 
                           required>
                    <span class="update-input-unit">P</span>
                </div>
            </div>

            <!-- 마일리지 설정 -->
            <div class="update-field">
                <label class="update-label">최대 마일리지 사용</label>
                <div class="update-input-with-unit">
                    <input type="number" 
                           class="update-input" 
                           name="max_mileage_use" 
                           value="${detail.max_mileage_use}">
                    <span class="update-input-unitM">M</span>
                </div>
            </div>

            <!-- 카테고리 -->
            <div class="update-field">
                <label class="update-label">상품 카테고리</label>
                <select class="update-select" name="item_ctg_id" required>
                    <option value="">카테고리를 선택하세요</option>
                    <c:forEach var="ctg" items="${itemCategoryList}">
                        <option value="${ctg.item_ctg_id}"
                            <c:if test="${ctg.item_ctg_id eq detail.item_ctg_id}">selected</c:if>>
                            ${ctg.item_ctg_name}
                        </option>
                    </c:forEach>
                </select>
            </div>

            <!-- 지역 -->
            <div class="update-field">
                <label class="update-label">거래 지역</label>
                <select class="update-select" name="toplct_id" id="toplct_id" required>
                    <option value="">지역을 선택하세요</option>
                    <c:forEach var="loc" items="${topLocationList}">
                        <option value="${loc.toplct_id}"
                            <c:if test="${loc.toplct_id eq detail.toplct_id}">
                                selected
                            </c:if>>
                            ${loc.toplct_name}
                        </option>
                    </c:forEach>
                </select>
            </div>

            <!-- 기본 주소 -->
            <div class="update-field">
                <label class="update-label">거래 상세 주소</label>
                <div class="update-input-row">
                    <input type="text"
                           class="update-input"
                           id="detail_address"
                           name="detail_address"
                           value="${detail.detail_address}"
                           placeholder="주소 검색 버튼을 눌러주세요"
                           readonly
                           required>
                    <button type="button" 
                            class="update-btn-search" 
                            id="btnSearchAddress">
                        주소 검색
                    </button>
                </div>
            </div>

            <!-- 상세 주소 추가 -->
            <div class="update-field">
                <input type="text"
                       class="update-input"
                       id="extra_address"
                       placeholder="상세 주소 입력 (동/호수 등)">
            </div>

            <!-- 버튼 그룹 -->
            <div class="update-button-group">
                <button type="submit" class="update-btn update-btn-primary">
                    수정 완료
                </button>
                <a href="/traBoard/detail?trade_id=${detail.trade_id}" class="update-btn update-btn-outline">
                    취소
                </a>
            </div>
        </form>
    </div>
</div>

<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
$(function(){
    console.log("update.jsp 로드 완료");

    // 이미지 미리보기
    $("#thumbFile").on("change", function(e){
        const file = e.target.files[0];
        if(file){
            const reader = new FileReader();
            reader.onload = function(e){
                $("#imagePreview").show().find("img").attr("src", e.target.result);
                $(".update-image-current").hide();
            };
            reader.readAsDataURL(file);
        }
    });

    // 주소 검색
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

    // 상세주소 추가 입력 시 병합
    $("#extra_address").on("blur", function(){
        let base = $("#detail_address").val();
        let extra = $(this).val();

        if(base && extra){
            let fullAddr = base + " " + extra;
            $("#detail_address").val(fullAddr);
            console.log("상세 주소 병합:", fullAddr);
        }
    });

    // 전송 전 필수값 검증
    $("form").on("submit", function(){
        console.log("폼 전송 시작");

        if($("#toplct_id").val() === ""){
            alert("거래 지역을 선택하세요.");
            return false;
        }

        if($("#detail_address").val() === ""){
            alert("주소를 입력하세요.");
            return false;
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