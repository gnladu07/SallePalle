<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/header.jsp"%>
<div class="main-profileEdit">
    <div class="profileEdit-container">
        <h1 class="profileEdit-title">프로필 사진 변경</h1>
        <p class="profileEdit-subtitle">새로운 프로필 사진을 업로드하세요</p>

        <form action="/member/profileEdit" method="post" enctype="multipart/form-data">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
            
            <!-- 프로필 이미지 미리보기 -->
            <div class="profileEdit-preview-section">
                <div class="profileEdit-preview-wrapper">
                    <img id="preview"
                         src="/upload/${loginInfo.profile_img}"
                         class="profileEdit-preview-img">
                    
                    <div class="profileEdit-preview-overlay">
                        <svg class="profileEdit-camera-icon" fill="white" viewBox="0 0 24 24">
                            <path d="M12 12.5c1.38 0 2.5-1.12 2.5-2.5S13.38 7.5 12 7.5 9.5 8.62 9.5 10s1.12 2.5 2.5 2.5zM12 9c.55 0 1 .45 1 1s-.45 1-1 1-1-.45-1-1 .45-1 1-1zm0-5c-4.97 0-9 4.03-9 9s4.03 9 9 9 9-4.03 9-9-4.03-9-9-9zm0 16c-3.86 0-7-3.14-7-7s3.14-7 7-7 7 3.14 7 7-3.14 7-7 7z"/>
                            <path d="M9 2L7.17 4H4c-1.1 0-2 .9-2 2v12c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V6c0-1.1-.9-2-2-2h-3.17L15 2H9zm3 15c-2.76 0-5-2.24-5-5s2.24-5 5-5 5 2.24 5 5-2.24 5-5 5z"/>
                        </svg>
                    </div>
                </div>
                
                <button type="button" class="profileEdit-cancel-btn" id="cancelBtn">
                    변경 취소
                </button>
            </div>

            <!-- 파일 업로드 -->
            <div class="profileEdit-upload-section">
                <label for="uploadFile" class="profileEdit-upload-label">
                    <svg class="icon" fill="#FF6F61" viewBox="0 0 24 24">
                        <path d="M19.35 10.04C18.67 6.59 15.64 4 12 4c-1.48 0-2.85.43-4.01 1.17l1.46 1.46C10.21 6.23 11.08 6 12 6c3.04 0 5.5 2.46 5.5 5.5v.5H19c1.66 0 3 1.34 3 3s-1.34 3-3 3h-6v2h6c2.76 0 5-2.24 5-5 0-2.64-2.05-4.78-4.65-4.96zM3 19h8v-2H3c-1.66 0-3-1.34-3-3s1.34-3 3-3h.5v-.5C3.5 7.46 5.96 5 9 5c.71 0 1.39.14 2.02.38L12.46 6.8C11.67 6.3 10.87 6 10 6 7.24 6 5 8.24 5 11v1H3c-1.1 0-2 .9-2 2s.9 2 2 2h8v2H3z"/>
                        <path d="M12 13l-4 4h3v4h2v-4h3z"/>
                    </svg>
                    <span>사진 선택하기</span>
                </label>
                <input type="file" 
                       name="uploadFile" 
                       id="uploadFile" 
                       accept="image/*"
                       style="display: none;">
            </div>

            <!-- 버튼 그룹 -->
            <div class="profileEdit-button-group">
                <button type="submit" class="profileEdit-btn profileEdit-btn-primary">
                    프로필 변경
                </button>
                <button type="button" class="profileEdit-btn profileEdit-btn-reset" id="resetDefaultBtn">
                    기본 이미지로 초기화
                </button>
                <a href="/member/read" class="profileEdit-btn profileEdit-btn-outline">
                    뒤로가기
                </a>
            </div>
        </form>
    </div>
</div>
<script>
	// 기존 프로필 이미지 저장
	var originalImg = "${loginInfo.profile_img}"
	
	// 미리보기
	$("#uploadFile").on("change", function(){
	
	    const file = this.files[0];
	    if (!file) return;
	
	    const reader = new FileReader();
	
	    reader.onload = function(e){
	        $("#preview").attr("src", e.target.result);
	    };
	
	    reader.readAsDataURL(file);
	});
	
	// 취소 버튼 (미리보기 원래 이미지로 되돌림)
	$("#cancelBtn").on("click", function(){
	    $("#preview").attr("src", "/upload/" + originalImg);
	    $("#uploadFile").val(""); // 파일 input 초기화
	});
	
	// 기본 이미지로 초기화
	$("#resetDefaultBtn").on("click", function(){

	    if(!confirm("기본 이미지(default_profile.png)로 초기화할까요?")) return;
	
	    $.ajax({
	        url: "/member/profileReset",
	        type: "post",
	        data: {
	            userid: "${loginInfo.userid}",
	            "${_csrf.parameterName}": "${_csrf.token}"
	        },
	        success: function(){
	            alert("기본 이미지로 초기화되었습니다.");
	            $("#preview").attr("src", "/upload/default_profile.png");
	            originalImg = "default_profile.png"; // 세션 반영 전 미리 적용
	        },
	        error: function(){
	            alert("초기화 중 오류 발생!");
	        }
	    });
	});
</script>
<%@ include file="../include/footer.jsp"%>