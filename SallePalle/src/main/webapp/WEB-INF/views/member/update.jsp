<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/header.jsp"%>
<c:if test="${!empty msg}">
    <script>alert("${msg}");</script>
</c:if>
<c:if test="${!empty mailMsg}">
    <script>alert("${mailMsg}");</script>
</c:if>

<div class="main-update">
    <div class="update-container">
        <h1 class="update-title">개인정보 수정</h1>
        <p class="update-subtitle">회원 정보를 수정하고 저장하세요</p>

        <form action="/member/update" method="post">
            <input type="hidden" id="emailVerified" name="emailVerified" value="false">

            <!-- 아이디 (수정 불가) -->
            <div class="update-field">
                <label class="update-label">아이디</label>
                <input type="text" 
                       class="update-input update-input-disabled" 
                       name="userid" 
                       id="userid" 
                       value="${loginInfo.userid}" 
                       disabled>
                <div class="update-field-notice">아이디는 변경할 수 없습니다</div>
            </div>

            <!-- 실명 (수정 불가) -->
            <div class="update-field">
                <label class="update-label">실명</label>
                <input type="text" 
                       class="update-input update-input-disabled" 
                       name="username" 
                       value="${loginInfo.username}" 
                       disabled>
                <div class="update-field-notice">실명은 변경할 수 없습니다</div>
            </div>

            <!-- 닉네임 (수정 가능) -->
            <div class="update-field">
                <label class="update-label">닉네임</label>
                <input type="text" 
                       class="update-input" 
                       name="nickname" 
                       value="${loginInfo.nickname}"
                       required>
            </div>

            <!-- 이메일 + 인증 -->
            <div class="update-field">
                <label class="update-label">이메일</label>
                <div class="update-input-row">
                    <input type="email" 
                           class="update-input" 
                           name="email" 
                           id="email" 
                           value="${loginInfo.email}"
                           required>
                    <button type="button" class="update-btn-check" id="btnEmailAuth">인증번호 받기</button>
                </div>
                <div id="emailMsg"></div>
            </div>

            <div class="update-field">
                <label class="update-label">인증번호</label>
                <div class="update-input-row">
                    <input type="text" 
                           class="update-input" 
                           id="emailCode" 
                           placeholder="인증번호 입력">
                    <button type="button" class="update-btn-check" id="btnEmailCheck">확인</button>
                </div>
                <div id="emailCodeMsg"></div>
            </div>

            <!-- 휴대폰 번호 (수정 불가) -->
            <div class="update-field">
                <label class="update-label">휴대폰 번호</label>
                <input type="text" 
                       class="update-input update-input-disabled" 
                       name="mobile" 
                       value="${loginInfo.mobile}" 
                       disabled>
                <div class="update-field-notice">휴대폰 번호는 변경할 수 없습니다</div>
            </div>

            <!-- 생년월일 (수정 불가) -->
            <div class="update-field">
                <label class="update-label">생년월일</label>
                <input type="text" 
                       class="update-input update-input-disabled" 
                       name="birth6" 
                       value="${loginInfo.birth6}" 
                       disabled>
                <div class="update-field-notice">생년월일은 변경할 수 없습니다</div>
            </div>

            <!-- 성별 (수정 불가) -->
            <div class="update-field">
                <label class="update-label">성별</label>
                <input type="text" 
                       class="update-input update-input-disabled" 
                       name="gender" 
                       value="${loginInfo.gender == 'M' ? '남자' : '여자'}" 
                       disabled>
                <div class="update-field-notice">성별은 변경할 수 없습니다</div>
            </div>

            <!-- 주소 (수정 가능) -->
            <div class="update-field">
                <label class="update-label">주소</label>
                <input type="text" 
                       class="update-input" 
                       name="address" 
                       id="address" 
                       value="${loginInfo.address}"
                       placeholder="주소 찾기 (클릭)"
                       readonly
                       required>
            </div>

            <!-- 상세 주소 (수정 가능) -->
            <div class="update-field">
                <label class="update-label">상세 주소</label>
                <input type="text" 
                       class="update-input" 
                       name="detail_address" 
                       id="detail_address" 
                       value="${loginInfo.detail_address}"
                       placeholder="상세주소 입력 (예: 봉우아파트 201동 1306호)"
                       required>
            </div>

            <!-- 버튼 그룹 -->
            <div class="update-button-group">
                <button type="submit" class="update-btn update-btn-primary">
                    저장
                </button>
                <button type="button" class="update-btn update-btn-reset" id="btnReset">
                    초기화
                </button>
                <a href="/member/read" class="update-btn update-btn-outline">
                    뒤로가기
                </a>
            </div>
        </form>
    </div>
</div>
<script type="text/javascript">

	let emailAuthCode = "";
	let emailVerified = false;
	
	// 1) 카카오 주소찾기 API
	$("#address").click(function(){
	    new daum.Postcode({
	        oncomplete: function(data){
	            // API에서 받아온 주소를 address 칸에 넣음
	            $("#address").val(data.roadAddress);
	            
	            // 바로 상세주소를 입력할 수 있게 detail_address 칸으로 포커스 이동
	            $("#detail_address").focus();
	        }
	    }).open();
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
	        $("#emailVerified").val("true");
	        $("#emailCodeMsg").html("인증 완료!").addClass("ok").removeClass("no");
	    } else {
	        emailVerified = false;
	        $("#emailVerified").val("false");
	        $("#emailCodeMsg").html("인증번호가 일치하지 않습니다.").addClass("no").removeClass("ok");
	    }
	
	    /* checkJoinReady() */;
	});
	
	// 이메일 바뀔 때 인증필드 강제 false 처리
	$("#email").on("input", function(){
	    $("#emailVerified").val("false");
	});
	
	// “저장” 버튼 누르기 전 검증
	$("form").submit(function(e){
	    const oriEmail = "${loginInfo.email}";
	    const newEmail = $("#email").val().trim();
	    const verified = $("#emailVerified").val();
	
	    // 이메일을 변경했는데 인증이 false라면 → 저장 차단
	    if(oriEmail !== newEmail && verified !== "true"){
	        alert("메일 인증을 진행해주세요!");
	        e.preventDefault();
	        return false;
	    }
	});
	
	// 3) 수정 내용 초기화
	$("#btnReset").click(function(){

	    if(!confirm("모든 정보를 초기값(첫 저장 이력)으로 복구하시겠습니까?")) return;

	    $.ajax({
	        url: "/member/update/reset",
	        type: "post",
	        data: {
	            "${_csrf.parameterName}": "${_csrf.token}"
	        },
	        success: function(){
	            alert("초기값으로 복구되었습니다.");
	            location.reload();
	        },
	        error: function(){
	            alert("복구 중 오류 발생!");
	        }
	    });

	});
</script>
<%@ include file="../include/footer.jsp"%>