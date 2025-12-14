<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 로그인 - 살래팔래</title>

<style>
    body {
        margin: 0;
        font-family: 'Noto Sans KR', sans-serif;
        background: linear-gradient(135deg, #FF6F61 0%, #9B59B6 100%);
        min-height: 100vh;
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .main-admin {
        width: 100%;
        display: flex;
        justify-content: center;
        padding: 40px 20px;
    }

    .admin-container {
        width: 100%;
        max-width: 450px;
        background: white;
        border-radius: 20px;
        padding: 50px 40px;
        box-shadow: 0 10px 40px rgba(0,0,0,0.2);
    }

    .admin-header {
        text-align: center;
        margin-bottom: 40px;
    }

    .admin-logo {
        font-size: 20px;
        font-weight: 800;
        background: linear-gradient(45deg, #FF6F61, #9B59B6);
        -webkit-background-clip: text;
        background-clip: text;
        color: transparent;
        margin-bottom: 8px;
    }

    .admin-title {
        font-size: 26px;
        font-weight: 700;
        color: #333;
        margin-bottom: 8px;
    }

    .admin-subtitle {
        font-size: 14px;
        color: #888;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 6px;
    }

    .admin-badge {
        display: inline-flex;
        align-items: center;
        gap: 5px;
        padding: 4px 10px;
        background: linear-gradient(135deg, #FF6F61, #9B59B6);
        border-radius: 12px;
        color: white;
        font-size: 12px;
        font-weight: 600;
    }

    .admin-shield-icon {
        width: 14px;
        height: 14px;
    }

    /* Form */
    .admin-form {
        margin-bottom: 20px;
    }

    .admin-field {
        margin-bottom: 20px;
    }

    .admin-input {
        width: 100%;
        padding: 14px 18px;
        border: 2px solid #e0e0e0;
        border-radius: 12px;
        font-size: 15px;
        box-sizing: border-box;
        transition: 0.3s;
        background-color: #f8f9fa;
    }

    .admin-input:focus {
        outline: none;
        border-color: #FF6F61;
        background-color: white;
        box-shadow: 0 0 0 4px rgba(255, 111, 97, 0.1);
    }

    .admin-input::placeholder {
        color: #aaa;
    }

    .admin-submit-btn {
        width: 100%;
        padding: 16px;
        background: linear-gradient(135deg, #FF6F61, #9B59B6);
        border: none;
        border-radius: 12px;
        color: white;
        font-size: 16px;
        font-weight: 700;
        cursor: pointer;
        transition: 0.3s;
        margin-top: 10px;
    }

    .admin-submit-btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 20px rgba(255, 111, 97, 0.4);
    }

    .admin-error-msg {
        padding: 12px 15px;
        background: #fff5f5;
        border: 1px solid #fc8181;
        border-radius: 10px;
        color: #c53030;
        font-size: 14px;
        margin-top: 15px;
        text-align: center;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 8px;
    }

    .admin-error-icon {
        width: 18px;
        height: 18px;
    }

    .admin-divider {
        display: flex;
        align-items: center;
        margin: 30px 0;
        color: #ccc;
        font-size: 13px;
    }

    .admin-divider::before,
    .admin-divider::after {
        content: '';
        flex: 1;
        height: 1px;
        background: #eee;
    }

    .admin-divider::before {
        margin-right: 15px;
    }

    .admin-divider::after {
        margin-left: 15px;
    }

    .admin-info {
        background: #f8f9fa;
        border-radius: 12px;
        padding: 20px;
        margin-top: 20px;
    }

    .admin-info-title {
        font-size: 13px;
        font-weight: 600;
        color: #666;
        margin-bottom: 10px;
        display: flex;
        align-items: center;
        gap: 6px;
    }

    .admin-info-icon {
        width: 16px;
        height: 16px;
    }

    .admin-info-list {
        list-style: none;
        padding: 0;
        margin: 0;
    }

    .admin-info-list li {
        font-size: 13px;
        color: #888;
        padding: 6px 0;
        padding-left: 18px;
        position: relative;
    }

    .admin-info-list li::before {
        content: "•";
        position: absolute;
        left: 0;
        color: #FF6F61;
        font-weight: 700;
    }

    .admin-back-btn {
        width: 100%;
        padding: 12px;
        background: white;
        border: 1px solid #ddd;
        border-radius: 10px;
        color: #666;
        font-size: 14px;
        font-weight: 600;
        cursor: pointer;
        transition: 0.2s;
        margin-top: 15px;
        text-align: center;
        text-decoration: none;
        display: block;
    }

    .admin-back-btn:hover {
        background: #f8f9fa;
        border-color: #FF6F61;
        color: #FF6F61;
    }
</style>

</head>
<body>

<div class="main-admin">
    <div class="admin-container">
        <!-- 헤더 -->
        <div class="admin-header">
            <div class="admin-logo">살래팔래</div>
            <h1 class="admin-title">관리자 로그인</h1>
            <div class="admin-subtitle">
                <span class="admin-badge">
                    <svg class="admin-shield-icon" fill="white" viewBox="0 0 24 24">
                        <path d="M12 1L3 5v6c0 5.55 3.84 10.74 9 12 5.16-1.26 9-6.45 9-12V5l-9-4zm0 10.99h7c-.53 4.12-3.28 7.79-7 8.94V12H5V6.3l7-3.11v8.8z"/>
                    </svg>
                    ADMIN ONLY
                </span>
            </div>
        </div>

        <!-- 로그인 폼 -->
        <form action="/member/loginProcess" method="post" class="admin-form">
            <div class="admin-field">
                <input type="text" 
                       class="admin-input" 
                       name="userid" 
                       placeholder="관리자 ID" 
                       required>
            </div>

            <div class="admin-field">
                <input type="password" 
                       class="admin-input" 
                       name="userpw" 
                       placeholder="비밀번호" 
                       required>
            </div>

            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">

            <button type="submit" class="admin-submit-btn">로그인</button>

            <c:if test="${param.error == 'fail'}">
                <div class="admin-error-msg">
                    <svg class="admin-error-icon" fill="#c53030" viewBox="0 0 24 24">
                        <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-2h2v2zm0-4h-2V7h2v6z"/>
                    </svg>
                    아이디 또는 비밀번호가 올바르지 않습니다
                </div>
            </c:if>
        </form>

        <div class="admin-divider">관리자 전용 페이지</div>

        <!-- 안내 정보 -->
        <div class="admin-info">
            <div class="admin-info-title">
                <svg class="admin-info-icon" fill="#666" viewBox="0 0 24 24">
                    <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-6h2v6zm0-8h-2V7h2v2z"/>
                </svg>
                안내사항
            </div>
            <ul class="admin-info-list">
                <li>관리자 권한이 필요한 페이지입니다</li>
                <li>승인된 계정으로만 접근 가능합니다</li>
                <li>보안을 위해 정기적으로 비밀번호를 변경해주세요</li>
            </ul>
        </div>

        <!-- 뒤로가기 -->
        <a href="/main/home" class="admin-back-btn">
            메인 페이지로 돌아가기
        </a>
    </div>
</div>

</body>
</html>