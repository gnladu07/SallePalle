<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<c:if test="${!empty param.msg}">
	    <script>
	        alert("${param.msg}");
	    </script>
	</c:if>	
	<!-- 로그인 X -->
	<sec:authorize access="isAnonymous()">
	    <a href="/member/login">로그인</a>
	    <a href="/member/join">회원가입</a>
	</sec:authorize>
	
	<!-- 로그인 O -->
	<sec:authorize access="isAuthenticated()">
	    <span>${loginInfo.userid}님 환영합니다!</span>
	    <a href="/member/read">내정보</a>
	        <form action="/member/logout" method="post" >
		        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
		        <button type="submit" >
		            로그아웃
		        </button>
		    </form>
	</sec:authorize>
	
	<!-- 관리자만 -->
	<sec:authorize access="hasRole('ROLE_ADMIN')">
	    <a href="/admin">관리자 페이지</a>
	</sec:authorize>
</body>
</html>