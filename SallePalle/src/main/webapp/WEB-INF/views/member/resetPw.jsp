<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/header.jsp"%>
</head>
<body>
	<form action="/member/resetPw" method="post">
	    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
	    <input type="hidden" name="token" value="${token}">
	
	    <label>새 비밀번호:</label>
	    <input type="password" name="newPw" required>
	
	    <button type="submit">비밀번호 재설정</button>
	</form>
<%@ include file="../include/footer.jsp"%>