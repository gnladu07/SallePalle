<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../include/header.jsp"%>
<div class="main-findId">
    <div class="findId-container">
        <h1 class="findId-title">아이디 찾기</h1>
        <p class="findId-subtitle">비밀번호를 입력하여 아이디를 확인하세요</p>

        <c:if test="${!empty msg}">
            <p style="color:red;">${msg}</p>
        </c:if>

        <form action="/member/findId" method="post">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
            
            <div class="findId-field">
                <label class="findId-label">비밀번호</label>
                <input type="password" 
                       class="findId-input" 
                       name="userpw" 
                       placeholder="비밀번호를 입력하세요" 
                       required>
            </div>

            <button type="submit" class="findId-submit-btn">아이디 찾기</button>
        </form>

        <div class="findId-divider">또는</div>

        <div class="findId-links">
            <button class="findId-link-btn" onclick="location.href='/member/findPw'">
                비밀번호 찾기
            </button>
            <button class="findId-link-btn" onclick="location.href='/member/login'">
                로그인 페이지로
            </button>
        </div>
    </div>
</div>
<%@ include file="../include/footer.jsp"%>