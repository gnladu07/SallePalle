<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<div class="header">관리자 페이지</div>
	
	<div class="container">
	    <div class="menu">
	        <a href="/admin/members">회원 관리</a>
	        <a href="/admin/sellerRequest">판매 권한 신청 관리</a>
	        <a href="/admin/items">물품 관리</a>
	    </div>
	
	    <h2 style="margin-top:30px;">관리자 대시보드</h2>
	    <p>관리자 로그인 성공! 운영 기능을 선택하세요.</p>
	</div>
</body>
</html>