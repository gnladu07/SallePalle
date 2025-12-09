<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/header.jsp"%>
<c:if test="${!empty joinMsg}">
	<script>
	    alert("${joinMsg}");
	</script>
</c:if>
<c:if test="${!empty rePwMsg}">
	<script>
	    alert("${rePwMsg}");
	</script>
</c:if>
<c:if test="${!empty pwMsg}">
	<script>
	    alert("${pwMsg}");
	</script>
</c:if>
<c:if test="${not empty foundId}">
	<script>
	    alert("아이디는 '${foundId}' 입니다.");
	</script>
</c:if>
<div class="main-login">
    <div class="login-container">
    <h1 class="login-title">로그인</h1>
	<form id="loginForm" action="/member/loginProcess" method="post">
	<!-- hidden타입 csrf 토큰 정보 -->
	<input type="hidden" name="${_csrf.parameterName }" 
	                     value="${_csrf.token }" >
		<c:if test="${param.error == 'fail' }">
			<script type="text/javascript">
				alert("입력하신 사용자 정보가 없습니다! 재확인 부탁드립니다.")
			</script>
		</c:if>
		<div class="login-inputs">
			<label class="login-label">아이디</label>
			<div>
				<input type="text" name="userid" placeholder="ID"
				       autocomplete="off" required >
			</div>
			<label class="login-label">비밀번호</label>
			<div>
				<input type="password" name="userpw" placeholder="Password"
				       required >
			</div>
		</div>
	</form>
	<div class="login-options">
		<button id="externalSubmitBtn" class="login-option-btn primary" type="submit" value="로그인">
	        <svg class="icon" fill="white" viewBox="0 0 24 24">
	            <path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/>
	        </svg>
	        살래팔래 로그인
	    </button>
		<div class="login-divider">또는</div>
		<button id="loginWithNaver" class="login-option-btn naver" >
	        <svg class="icon" fill="white" viewBox="0 0 24 24">
	            <path d="M16.273 12.845L7.376 0H0v24h7.726V11.156L16.624 24H24V0h-7.727v12.845z"/>
	        </svg>
	        네이버로 간편 로그인
	    </button>
    </div>
	<p class="login-footMenu"><a href="/member/joinChoice">회원가입 </a>|<a href="/member/findId"> 아이디 찾기</a></p>
	<input type="hidden" name="result">
	</div>
</div>
<script type="text/javascript">
	$(function() {
		
		// 로그인 버튼 출력
		$("#externalSubmitBtn").on("click", function() {
		    $("#loginForm").submit();  // ★ form 강제 제출
		});

/* 	    // 1) 회원가입 메시지 출력
	    const message = '${joinMsg}';
	    if (message !== '') {
	        swal('회원 가입 결과', message, 'success');
	    } */

	    // 2) 네이버 로그인 버튼 클릭 이벤트
	    $('#loginWithNaver').on('click', function(e) {
	        e.preventDefault();

	        const url = '${naverLoginURL}';
	        const name = '_blank';
	        const options = 'menubar=no, toolbar=no, width=700, height=1000';

	        const popup = window.open(url, name, options);

	        // 팝업 닫힘 감지
	        const timer = setInterval(function() {
	            if (popup.closed) {
	                clearInterval(timer);
	                afterClosePopup();
	            }
	        }, 1000);
	    });

	    // 3) 팝업 닫힌 후 처리
	    function afterClosePopup() {
	    	
	        const json = $('input[name="result"]').val();
	        
	        if (!json || json.trim() === "") {
	            console.warn("네이버 callback 값이 없음");
	            return;
	        }
	        
	        const result = JSON.parse(json);
	        console.log(result);
	        
	        // 기존회원일 때 자동 로그인 추가됨
	        if (result.success === true) {
	            location.href = '/main/home';     // 로그인 성공 후 이동할 페이지
	            return;
	        }

	        // 신규회원이면 회원가입 안내
	        if (result.success === false) {
	            swal({
	                title: '연동된 계정이 없습니다',
	                text: '회원가입으로 이동합니다',
	                type: 'info',
	                showCancelButton: true,
	                confirmButtonText: '예',
	                cancelButtonText: '아니오',
	                closeOnConfirm: false,
	                closeOnCancel: false
	            }, function(isConfirm) {
	                if (isConfirm) {
	                    location.href = '/member/join';
	                }
	            });
	        }
	    }
	});
</script>
<%@ include file="../include/footer.jsp"%>