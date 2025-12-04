<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>아이디 찾기</title>
</head>
<body>
	<h2>아이디 찾기</h2>
	
	<c:if test="${!empty msg}">
	    <p style="color:red;">${msg}</p>
	</c:if>
	
	<form action="/member/findId" method="post">
	<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }">
	    <label>비밀번호 입력:</label>
	    <input type="password" name="userpw" required>
	    <button type="submit">아이디 찾기</button>
	</form>
	
	<hr>

	<!-- 비밀번호 찾기 -->
	<button onclick="location.href='/member/findPw'">비밀번호 찾기</button>
	
	<!-- 뒤로가기 -->
	<button onclick="location.href='/member/login'">뒤로가기</button>
</body>
</html>