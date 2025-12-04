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
	<h2>비밀번호 재설정 링크 요청</h2>

	<c:if test="${not empty msg}">
	    <p style="color:red;">${msg}</p>
	</c:if>
	
	<form action="/member/findPw" method="post">
	
	    <!-- CSRF 토큰 필수 -->
	    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
	
	    <label>아이디:</label>
	    <input type="text" name="userid" required> <br>
	
	    <label>이메일:</label>
	    <input type="email" name="email" required> <br>
	
	    <button type="submit">비밀번호 재설정 링크 발송</button>
	</form>
	
	<hr>
	
	<button onclick="location.href='/member/login'">뒤로가기</button>
</body>
</html>