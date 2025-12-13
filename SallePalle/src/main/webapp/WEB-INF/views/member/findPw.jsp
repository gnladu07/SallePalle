<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/header.jsp"%>
<div class="main-findId">
	<div class="findId-container">
		<h1 class="findId-title" >비밀번호 재설정 링크 요청</h1>
		<p class="findId-subtitle">비밀번호를 재설정하는 메일을 요청합니다.</p>

		<c:if test="${!empty msg}">
		    <p style="color:red;">${msg}</p>
		</c:if>
		
		<form action="/member/findPw" method="post">
		    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
			<div class="findId-field">
				<label class="findId-label">아이디</label>
				<input type="text" 
				       class="findId-input" 
				       name="userid" 
				       placeholder="아이디를 입력하세요"
				       required>
			</div>
			
			<div class="findId-field">
				<label class="findId-label">이메일</label>
				<input type="email" 
				       class="findId-input" 
				       name="email" 
				       placeholder="등록된 메일주소를 입력하세요"
				       required>
			</div>
		
		    <button type="submit" class="findId-submit-btn" >비밀번호 재설정 링크 발송</button>
		</form>
		
		<div class="findId-divider">또는</div>
		
		<div class="findId-links">
			<button class="findId-link-btn" onclick="location.href='/member/login'">뒤로가기</button>
		</div>
	</div>
</div>

<%@ include file="../include/footer.jsp"%>