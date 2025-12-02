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
<c:if test="${empty loginInfo}">
    <script>
        alert("로그인이 필요합니다.");
        location.href='/member/login';
    </script>
</c:if>
	<h1>/views/read.jsp</h1>
	<fieldset>
		<legend>회원정보</legend>
		<div>
			<img src="/upload/${loginInfo.profile_img}" width="100" height="100">
		</div>
		<ul>
			<li>아이디: ${loginInfo.userid }</li>
			<li>실명  : ${loginInfo.username }</li>
			<li>닉네임: ${loginInfo.nickname }</li>
			<li>이메일: ${loginInfo.email }</li>
			<li>성별  : ${loginInfo.gender }</li>
			<li>주소  : ${loginInfo.detail_address }</li>
		</ul>
		<hr>
		<a href="/member/update">회원정보수정</a>
	</fieldset>
	<script type="text/javascript">
		var updateInfo = '${updateInfo}';
		
		if(updateInfo == "success") {
			alert("회원 정보가 수정되었습니다.")
		}
	</script>
</body>
</html>