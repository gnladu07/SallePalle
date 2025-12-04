<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
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
	<a href="/member/join">회원가입하기</a>
	<a href="/member/findId">아이디 찾기</a>
	</form>
	
</body>
</html>