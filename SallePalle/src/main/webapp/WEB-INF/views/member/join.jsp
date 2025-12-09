<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../include/header.jsp"%>
<c:if test="${!empty msg}">
    <script>alert("${msg}");</script>
</c:if>

<div class="main-join">
    <div class="join-container">
        <h1 class="join-title">회원가입</h1>
        <p class="join-subtitle">누군가의 기억이 나에게 새로움이 되는 순간, 살래팔래</p>

        <form method="post" id="joinForm">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
            <input type="hidden" name="provider" value="LOCAL">
            <input type="hidden" name="provider_id">
            <input type="hidden" id="idCheckStatus" value="N">

            <!-- 아이디 -->
            <div class="join-field">
                <label class="join-label">아이디</label>
                <div class="join-input-row">
                    <input type="text" class="join-input" name="userid" id="userid" placeholder="아이디 입력 (5~20자)" required>
                    <button type="button" class="join-btn-check" id="btnCheckId">중복검사</button>
                </div>
                <div id="useridMsg"></div>
            </div>

            <!-- 비밀번호 -->
            <div class="join-field">
                <label class="join-label">비밀번호</label>
                <input type="password" class="join-input" name="userpw" id="userpw" placeholder="비밀번호 (8~20자)" required>
                <div id="userpwMsg"></div>
            </div>

            <!-- 실명 -->
            <div class="join-field">
                <label class="join-label">실명</label>
                <input type="text" class="join-input" name="username" placeholder="실명" required>
            </div>

            <!-- 닉네임 -->
            <div class="join-field">
                <label class="join-label">닉네임</label>
                <input type="text" class="join-input" name="nickname" placeholder="닉네임" required>
            </div>

            <!-- 성별 -->
            <div class="join-field">
                <label class="join-label">성별</label>
                <div class="join-radio-group">
                    <label class="join-radio-label"><input type="radio" name="gender" value="M" required> 남자</label>
                    <label class="join-radio-label"><input type="radio" name="gender" value="F" required> 여자</label>
                </div>
            </div>

            <!-- 이메일 + 인증번호 -->
            <div class="join-field">
                <label class="join-label">이메일</label>
                <div class="join-input-row">
                    <input type="email" class="join-input" name="email" id="email" placeholder="이메일 입력" required>
                    <button type="button" class="join-btn-check" id="btnEmailAuth">인증번호 받기</button>
                </div>
                <div id="emailMsg"></div>
            </div>

            <div class="join-field">
                <div class="join-input-row">
                    <input type="text" class="join-input" id="emailCode" placeholder="인증번호 입력">
                    <button type="button" class="join-btn-check" id="btnEmailCheck">확인</button>
                </div>
                <div id="emailCodeMsg"></div>
            </div>

            <!-- 지역 선택 -->
            <div class="join-field">
                <label class="join-label">거주 지역</label>
                <select class="join-select" name="toplct_id" required>
                    <option value="">-- 지역 선택 --</option>
                    <c:forEach var="loc" items="${topList}">
                        <option value="${loc.toplct_id}">
                            ${loc.toplct_name}
                        </option>
                    </c:forEach>
                </select>
            </div>

            <!-- 상세주소 -->
            <div class="join-field">
                <label class="join-label">상세주소</label>
                <input type="text" class="join-input" name="detail_address" id="detail_address" 
                       placeholder="상세주소 찾기 (클릭)" readonly required>
            </div>

            <!-- 생년월일 -->
            <div class="join-field">
                <label class="join-label">생년월일</label>
                <div class="join-birth-group">
                    <select class="join-select" id="birth_year" required>
                        <option value="">년도</option>
                        <%
                            int yearNow = java.time.LocalDate.now().getYear();
                            for(int y = yearNow - 100; y <= yearNow - 10; y++){
                        %>
                            <option value="<%=y%>"><%=y%></option>
                        <%
                            }
                        %>
                    </select>

                    <select class="join-select" id="birth_month" required>
                        <option value="">월</option>
                        <c:forEach begin="1" end="12" var="m">
                            <option value="${m < 10 ? '0'+m : m}">${m}</option>
                        </c:forEach>
                    </select>

                    <select class="join-select" id="birth_day" required>
                        <option value="">일</option>
                        <c:forEach begin="1" end="31" var="d">
                            <option value="${d < 10 ? '0'+d : d}">${d}</option>
                        </c:forEach>
                    </select>
                </div>
                <input type="hidden" name="birth6" id="birth6">
            </div>

            <!-- 휴대폰 번호 -->
            <div class="join-field">
                <label class="join-label">휴대폰 번호</label>
                <input type="text" class="join-input" name="mobile" id="mobile" placeholder="010-1234-5678" required>
                <div id="mobileMsg"></div>
            </div>

            <!-- 약관 동의 -->
            <div class="join-field">
                <label class="join-label">약관 동의</label>
                <div class="join-checkbox-group">
                    <label class="join-checkbox-label"><input type="checkbox" name="agree_terms_required" value="Y" required> (필수) 이용약관 동의</label>
                    <label class="join-checkbox-label"><input type="checkbox" name="agree_privacy_required" value="Y" required> (필수) 개인정보 동의</label>
                    <label class="join-checkbox-label"><input type="checkbox" name="agree_location_optional" value="Y"> (선택) 위치기반서비스 동의</label>
                    <label class="join-checkbox-label"><input type="checkbox" name="agree_marketing_email" value="Y"> (선택) 마케팅 메일 수신</label>
                    <label class="join-checkbox-label"><input type="checkbox" name="agree_marketing_sms" value="Y"> (선택) 마케팅 SMS 수신</label>
                </div>
            </div>

            <!-- 제출 -->
            <input type="submit" class="join-submit-btn" value="회원가입하기" id="joinSubmit" disabled>

            <div class="join-login-link">
                이미 계정이 있으신가요? <a href="login.jsp">로그인</a>
            </div>
        </form>
    </div>
</div>
		<!-- 아이디 중복 모달 -->
<div id="idModal">
    <div class="join-modal-content">
        <h3 id="idModalMsg">결과 메시지</h3>
        <button type="button" class="join-modal-btn" id="idModalClose">확인</button>
    </div>
</div>

<script>

	let emailAuthCode = "";
	let emailVerified = false;
	let idAvailable = false;

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
	         .html("조건식에 만족합니다. 중복검사를 진행해주세요!")
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

	// 이메일 인증번호 AJAX 요청
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


    // 카카오 주소찾기 API
	$("#detail_address").click(function(){
	    new daum.Postcode({
	        oncomplete: function(data){
	            $("#detail_address").val(data.roadAddress);
	        }
	    }).open();
	});


    // 조건 만족시 submit 활성화
	function checkJoinReady(){
	    let id_ok = useridRegex.test($("#userid").val());
	    let pw_ok = userpwRegex.test($("#userpw").val());
	
	    if(id_ok && pw_ok && emailVerified){
	        $("#joinSubmit").prop("disabled", false);
	    } else {
	        $("#joinSubmit").prop("disabled", true);
	    }
	}
   
	// 중복검사 버튼 클릭
	$("#btnCheckId").click(function(){

	    const userid = $("#userid").val().trim();

	    if(userid === ""){
	        showIdModal("아이디를 입력해주세요.");
	        return;
	    }

	    if(!useridRegex.test(userid)){
	        showIdModal("아이디 형식이 올바르지 않습니다.");
	        return;
	    }

	    $.ajax({
	        url: "/member/checkUserid",
	        type: "post",
	        data: {
	            userid: userid,
	            "${_csrf.parameterName}": "${_csrf.token}"
	        },
	        success: function(result){

	        	if(result === "exists"){
	        	    idAvailable = false;
	        	    $("#idCheckStatus").val("N");
	        	    showIdModal("이미 사용중인 아이디입니다.");
	        	} else {
	        	    idAvailable = true;
	        	    $("#idCheckStatus").val("Y");
	        	    showIdModal("사용 가능한 아이디입니다!");
	        	}

	            checkJoinReady();
	        },
	        error: function(){
	            showIdModal("서버 오류! 다시 시도해주세요.");
	        }
	    });

	});
	
	$("#joinForm").on("submit", function(e) {
        if ($("#idCheckStatus").val() !== "Y") {
            e.preventDefault();
            alert("아이디 중복검사를 먼저 진행해주세요.");
            return false;
        }
    });

	// 모달 함수
	function showIdModal(msg){
	    $("#idModalMsg").html(msg);
	    $("#idModal").css("display", "flex");
	}

	$("#idModalClose").click(function(){
	    $("#idModal").hide();
	});
	
	// 생년월일 검증
	function pad2(n) {
	    return n.toString().padStart(2, '0');
	}
	
	$("form").on("submit", function() {
	
	    let yy = $("#birth_year").val().substring(2, 4);   // 1993 → 93
	    let mm = pad2($("#birth_month").val());            // 1 → 01
	    let dd = pad2($("#birth_day").val());              // 9 → 09
	
	    let birth6 = yy + mm + dd;
	
	    // 숨겨진 필드에 세팅
	    $("#birth6").val(birth6);
	});

	// 휴대폰 번호 검증
	const mobileRegex = /^[0-9]{3}-[0-9]{4}-[0-9]{4}$/;

	$("#mobile").on("keyup", function(){
	    let val = $(this).val().trim();

	    if(mobileRegex.test(val)){
	        $("#mobileMsg").html("사용 가능한 번호입니다.").removeClass("no").addClass("ok");
	    } else {
	        $("#mobileMsg").html("형식: 010-1234-5678").removeClass("ok").addClass("no");
	    }
	});
</script>
<%@ include file="../include/footer.jsp"%>