<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입</title>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<!-- 카카오 주소찾기 API -->
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<style>
    .ok { color: blue !important; font-size: 13px; }
    .no { color: red !important; font-size: 13px; }
    .hint { color: green !important; font-size: 13px; }
</style>

</head>
<body>

<h1>회원가입</h1>

<form method="post">
<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">

<fieldset>
    <legend>회원가입</legend>

    <!-- 아이디 -->
    <div>
        <input type="text" name="userid" id="userid" placeholder="아이디 입력 (5~20자)" required>
        <div id="useridMsg"></div>
    </div>

    <!-- 비밀번호 -->
    <div>
        <input type="password" name="userpw" id="userpw" placeholder="비밀번호 (8~12자)" required>
        <div id="userpwMsg"></div>
    </div>

    <!-- 실명 -->
    <div>
        <input type="text" name="username" placeholder="실명" required>
    </div>

    <!-- 닉네임 -->
    <div>
        <input type="text" name="nickname" placeholder="닉네임" required>
    </div>

    <!-- 성별 -->
    <div>
        <label><input type="radio" name="gender" value="M" required> 남자</label>
        <label><input type="radio" name="gender" value="F" required> 여자</label>
    </div>

    <!-- 이메일 + 인증번호 -->
    <div>
        <input type="email" name="email" id="email" placeholder="이메일 입력" required>
        <button type="button" id="btnEmailAuth">인증번호 받기</button>
        <div id="emailMsg"></div>
    </div>

    <div>
        <input type="text" id="emailCode" placeholder="인증번호 입력">
        <button type="button" id="btnEmailCheck">확인</button>
        <div id="emailCodeMsg"></div>
    </div>

    <!-- 지역 선택 -->
    <div>
        <select name="toplct_id" required>
            <option value="">-- 지역 선택 --</option>
            <c:forEach var="loc" items="${topList}">
                <option value="${loc.toplct_id}">
                    ${loc.toplct_name}
                </option>
            </c:forEach>
        </select>
    </div>

    <!-- 상세주소 (카카오 주소찾기) -->
    <div>
        <input type="text" name="detail_address" id="detail_address" 
               placeholder="상세주소 찾기 (클릭)" readonly required >
    </div>

    <!-- 약관 동의 -->
    <div>
        <label><input type="checkbox" name="agree_terms_required" value="Y" required> (필수) 이용약관 동의</label><br>
        <label><input type="checkbox" name="agree_privacy_required" value="Y" required> (필수) 개인정보 동의</label><br>
        <label><input type="checkbox" name="agree_location_optional" value="Y"> (선택) 위치기반서비스 동의</label><br>
        <label><input type="checkbox" name="agree_marketing_email" value="Y"> (선택) 마케팅 메일 수신</label><br>
        <label><input type="checkbox" name="agree_marketing_sms" value="Y"> (선택) 마케팅 SMS 수신</label>
    </div>

    <hr>

    <div>
        <input type="submit" value="회원가입하기" id="joinSubmit" disabled>
    </div>

</fieldset>

</form>


<script>

	let emailAuthCode = "";
	let emailVerified = false;

	// 정규식 패턴
	const useridRegex = /^[a-zA-Z0-9-_@]{5,20}$/;
	const userpwRegex = /^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*()_\-+=\[\]{}|;:'",.<>?\/\\]).{8,20}$/;
	
	// 아이디 안내 메시지
	$("#userid").on("focus", function () {
	 $("#useridMsg")
	     .html("아이디 조건: 5~20자 / 영문,숫자,-,_ ,@")
	     .removeClass("no ok")
	     .addClass("hint");
	});
	
	$("#userid").on("keyup", function () {
	 let val = $(this).val();
	 
	 if (useridRegex.test(val)) {
	     $("#useridMsg")
	         .html("사용 가능한 아이디입니다.")
	         .removeClass("no hint")
	         .addClass("ok");
	 } else {
	     $("#useridMsg")
	         .html("아이디 조건: 5~20자 / 영문,숫자,-,_ ,@")
	         .removeClass("ok hint")
	         .addClass("no");
	 }
	
	 checkJoinReady();
	});
	

	// 비밀번호 안내 메시지
	$("#userpw").on("focus", function () {
	    let val = $(this).val().trim();
	    
	    if (val === "") {
	        $("#userpwMsg")
	            .removeClass("no ok hint")
	            .addClass("hint")
	            .html("8~20자 / 대문자+소문자+숫자+특수문자 포함");
	    }
	});
	
	$("#userpw").on("keyup", function () {
	    let val = $(this).val().trim();  

	    if (userpwRegex.test(val)) {
	        $("#userpwMsg")
	            .removeClass("no ok hint")
	            .addClass("ok")
	            .html("사용 가능한 비밀번호입니다.");
	    } else {
	        $("#userpwMsg")
	            .removeClass("no ok hint")
	            .addClass("no")
	            .html("8~20자 / 대문자+소문자+숫자+특수문자 포함");
	    }

	    checkJoinReady();
	});

	// 2) 이메일 인증번호 AJAX 요청
	$("#btnEmailAuth").click(function(){
	    const email = $("#email").val().trim();
	
	    if(email.trim() == ""){
	        alert("이메일을 입력해주세요.");
	        return;
	    }
	
	    $.ajax({
	        url: "/member/emailCode",
	        type: "post",
	        data: {email: email},
	        success: function(code){
	            emailAuthCode = code;
	            $("#emailMsg").removeClass().addClass("ok")
	                .html("인증번호가 전송되었습니다.");
	        },
	        error: function(xhr){
	            console.error("AJAX 오류", xhr);
	            alert("서버와 통신에 실패했습니다.");
	        }
	    });
	});

	// 인증번호 확인
	$("#btnEmailCheck").click(function(){
	    const val = $("#emailCode").val();
	
	    if(val == emailAuthCode){
	        emailVerified = true;
	        $("#emailCodeMsg").html("인증 완료!").addClass("ok").removeClass("no");
	    } else {
	        emailVerified = false;
	        $("#emailCodeMsg").html("인증번호가 일치하지 않습니다.").addClass("no").removeClass("ok");
	    }
	
	    checkJoinReady();
	});


   // 3) 카카오 주소찾기 API

	$("#detail_address").click(function(){
	    new daum.Postcode({
	        oncomplete: function(data){
	            $("#detail_address").val(data.roadAddress);
	        }
	    }).open();
	});


   // 4) 모든 조건 만족하면 submit 활성화

	function checkJoinReady(){
	    let id_ok = useridRegex.test($("#userid").val());
	    let pw_ok = userpwRegex.test($("#userpw").val());
	
	    if(id_ok && pw_ok && emailVerified){
	        $("#joinSubmit").prop("disabled", false);
	    } else {
	        $("#joinSubmit").prop("disabled", true);
	    }
	}
</script>

</body>
</html>