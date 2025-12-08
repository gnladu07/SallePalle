<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="cpath" value="${pageContext.request.contextPath }" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<title>Insert title here</title>
<style>
	input[type="image"] {
		width: 300px;
	}
</style>
</head>
<body>
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
	<form action="/member/loginProcess" method="post">
	<!-- hidden타입 csrf 토큰 정보 -->
	<input type="hidden" name="${_csrf.parameterName }" 
	                     value="${_csrf.token }" >
	<fieldset>
		<legend>로그인</legend>
		<c:if test="${param.error == 'fail' }">
			<script type="text/javascript">
				alert("입력하신 사용자 정보가 없습니다! 재확인 부탁드립니다.")
			</script>
		</c:if>
		<div>
			<label>아이디</label>
			<div>
				<input type="text" name="userid" placeholder="ID"
				       autocomplete="off" required >
			</div>
			<label>비밀번호</label>
			<div>
				<input type="password" name="userpw" placeholder="Password"
				       required >
			</div>
		</div>
	</fieldset>
	<input type="submit" value="로그인">
	</form>
	<p><img src="${cpath }/resources/naver/btn_naver.png" ><input id="loginWithNaver" type="image" src="${cpath }/resources/naver/btn_naver.png"></p>
	<p><a href="/member/join">회원가입 </a>|<a href="/member/findId"> 아이디 찾기</a></p>
	<input type="hidden" name="result">
<script type="text/javascript">
	$(function() {

	    // 1) 회원가입 메시지 출력
	    const message = '${joinMsg}';
	    if (message !== '') {
	        swal('회원 가입 결과', message, 'success');
	    }

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
	        const result = JSON.parse(json);
	        console.log(result);

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
</body>
</html>