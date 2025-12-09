<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<fieldset>
	<legend>adminLogin</legend>
		<form action="">
		<input type="hidden" name="${_csrf.parameterName }" 
	                         value="${_csrf.token }" >	
		<div>		
			<label>아이디</label>
			<input type="text" name="userid" placeholder="ID"  autocomplete="off" required>
		</div>
		<div>
			<label>비밀번호</label>
			<input type="password" name="userpw" placeholder="Password" required> 
		</div>
		<hr>
		<div>
			<input type="submit" value="로그인">
		</div>
		</form>
	</fieldset>
</body>
</html>