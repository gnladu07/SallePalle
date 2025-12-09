<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/header.jsp"%>
</head>
<body>
	<form action="/member/profileEdit" method="post" enctype="multipart/form-data">
	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">	
		<fieldset>
			<legend>프로필 이미지 변경</legend>
		    <div>
		        <img id="preview" 
		             src="/upload/${loginInfo.profile_img}"
		             class="preview-img" >
		        <button type="button" id="cancelBtn">변경 취소</button>
		    </div>
		
		    <input type="file" name="uploadFile" id="uploadFile" accept="image/*">
		
		    <br><br>
		
		    <button type="submit">프로필 이미지 변경</button>
        	<button type="button" id="resetDefaultBtn">기본 이미지로 초기화</button>
		    
		    <a href="/member/read"><button type="button">뒤로가기</button></a>
		</fieldset>
	</form>
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