<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/header.jsp"%>
</head>
<body>
<c:if test="${empty loginInfo}">
    <script>
        alert("로그인이 필요합니다.");
        location.href='/member/login';
    </script>
</c:if>
<c:if test="${!empty imageMsg}">
    <script>alert("${imageMsg}");</script>
</c:if>
<c:if test="${!empty msg}">
    <script>alert("${msg}");</script>
</c:if>
	<h1>/views/read.jsp</h1>
	<fieldset>
		<legend>회원정보</legend>
		<div>
			<img src="/upload/${loginInfo.profile_img}" class="preview-img">
		</div>
		<div>
			<a href="/member/profileEdit">프로필 변경</a>
		</div>
		<ul>
			<li>아이디  : ${loginInfo.userid }</li>
			<li>실명    : ${loginInfo.username }</li>
			<li>닉네임  : ${loginInfo.nickname }</li>
			<li>이메일  : ${loginInfo.email }</li>
			<li>번호    : ${loginInfo.mobile }</li>
			<li>생년월일: ${loginInfo.birth6 }</li>
			<li>성별    : ${loginInfo.gender }</li>
			<li>주소    : ${loginInfo.detail_address }</li>
		</ul>
		<hr>
		<a href="/member/update"><button type="button">회원정보수정</button></a>
		<button type="button" id="btnDeleteOpen">회원탈퇴</button>
		<a href="/main/home"><button type="button">홈으로</button></a>
	</fieldset>
	<!-- 탈퇴 모달 -->
	<div id="deleteModal" style="
	    display:none;
	    position:fixed; top:0; left:0; width:100%; height:100%;
	    background:rgba(0,0,0,0.6); justify-content:center; align-items:center;">
	    
	    <div style="background:white; padding:20px; border-radius:10px; width:300px;">
	        <h3>비밀번호 확인</h3>
	        <input type="password" id="userpw" placeholder="비밀번호 입력" style="width:100%;">
	        <br><br>
	
	        <button type="button" id="btnCheckPw">확인</button>
	        <button type="button" id="btnCloseModal">취소</button>
	    </div>
	</div>
	<script type="text/javascript">
		var updateInfo = '${updateInfo}';
		
		if(updateInfo == "success") {
			alert("회원 정보가 수정되었습니다.")
		}
		
		/* 모달 열기 */
		$("#btnDeleteOpen").click(function(){
		    $("#deleteModal").css("display", "flex");
		});

		/* 모달 닫기 */
		$("#btnCloseModal").click(function(){
		    $("#deleteModal").hide();
		});

		/* 비밀번호 체크 */
		$("#btnCheckPw").click(function(){

		    const pw = $("#userpw").val().trim();

		    if(pw === ""){
		        alert("비밀번호를 입력해주세요.");
		        return;
		    }

		    $.ajax({
		        url: "/member/checkPw",
		        type: "post",
		        data: {
		            userpw: pw,
		            "${_csrf.parameterName}": "${_csrf.token}"
		        },
		        success: function(result){

		            if(result === "ok"){
		                if(confirm("정말로 탈퇴하시겠습니까?")){
		                    deleteAccount();
		                }
		            } else {
		                alert("비밀번호가 일치하지 않습니다.");
		            }
		        },
		        error: function(){
		            alert("서버 오류 발생");
		        }
		    });
		});

		/* 실제 탈퇴 AJAX */
		function deleteAccount(){

		    $.ajax({
		        url: "/member/delete",
		        type: "post",
		        data: {
		            "${_csrf.parameterName}": "${_csrf.token}"
		        },
		        success: function(result){
		            alert("회원 탈퇴가 완료되었습니다.");
		            location.href="/";
		        },
		        error: function(){
		            alert("탈퇴 처리 중 오류 발생");
		        }
		    });

		}
	</script>
<%@ include file="../include/footer.jsp"%>