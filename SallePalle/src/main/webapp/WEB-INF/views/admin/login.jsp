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
	<div class="login-box">
	    <div class="login-title">관리자 로그인</div>
	
	    <form action="/admin/loginProc" method="post">
	        <input type="text" name="userid" placeholder="관리자 ID" required>
	        <input type="password" name="userpw" placeholder="비밀번호" required>
	
	        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
	
	        <button type="submit">로그인</button>
	
	        <c:if test="${param.error == 'fail'}">
	            <div class="error-msg">아이디 또는 비밀번호가 올바르지 않습니다.</div>
	        </c:if>
	    </form>
	</div>
</body>
</html>