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
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<title>Insert title here</title>
<style>
	/* header.jsp */
	header {
        position: fixed;
        top: 0;
        width: 100%;
        height: 70px;
        background: white;
        border-bottom: 1px solid #eee;
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 0 20px;
        box-sizing: border-box;
        z-index: 99;
    }

    .logo {
        font-size: 22px;
        font-weight: 800;
        cursor: pointer;
        background: linear-gradient(45deg, #FF6F61, #9B59B6);
        -webkit-background-clip: text;
        color: transparent;
    }

    .menu-group {
        display: flex;
        gap: 20px;
    }

    .auth-group {
        display: flex;
        gap: 15px;
    }

    .auth-group button {
        padding: 7px 14px;
        border-radius: 8px;
        border: 1px solid #ddd;
        background: white;
        cursor: pointer;
        font-weight: 500;
    }
    .logo a {
	    text-decoration: none;   /* 밑줄 제거 */
	    color: inherit;          /* 부모 색상 그대로 사용 */
	    font: inherit;           /* 부모 폰트 그대로 */
	    padding: 0;
	    margin: 0;
	    background: none;
	    border: none;
	    outline: none;
	}
	.menu-group button {
	    background: none;
	    border: none;
	    font-size: 15px;
	    color: #333;
	    font-weight: 500;
	    cursor: pointer;
	    padding: 8px 14px;
	    border-radius: 8px;
	    transition: 0.2s;
	}
	
	.menu-group button:hover {
	    background: #f3f3f3;
	}
	
	.menu-group button:active {
	    background: #e9e9e9;
	}

	/* login.jsp */
	input[type="image"] {
		width: 300px;
	}
	
	/* profileEdit.jsp */
	.preview-img {
	    width: 150px;
	    height: 150px;
	    border-radius: 50%;
	    border: 1px solid #ddd;
	    object-fit: cover;
	}
	
	/* read.jsp */
	.preview-img {
	    width: 150px;
	    height: 150px;
	    border-radius: 50%;
	    border: 1px solid #ddd;
	    object-fit: cover;
	}
	
	/* update.jsp */
	.ok { color: blue !important; font-size: 13px; }
    .no { color: red !important; font-size: 13px; }
    .hint { color: green !important; font-size: 13px; }
    
    /* joinChoice.jsp */
    .main-joinChoice {
        margin-top: 70px;
        min-height: calc(100vh - 140px);
        display: flex;
        align-items: center;
        justify-content: center;
        padding: 40px 20px;
    }

    .join-container {
        width: 100%;
        max-width: 480px;
        background: white;
        border-radius: 16px;
        padding: 50px 40px;
        box-shadow: 0 2px 12px rgba(0,0,0,0.08);
    }

    .join-title {
        text-align: center;
        font-size: 28px;
        font-weight: 700;
        margin-bottom: 12px;
        color: #333;
    }

    .join-subtitle {
        text-align: center;
        font-size: 15px;
        color: #888;
        margin-bottom: 40px;
    }

    .join-options {
        display: flex;
        flex-direction: column;
        gap: 16px;
    }

    .join-option-btn {
        width: 100%;
        padding: 18px 20px;
        border-radius: 12px;
        border: 2px solid #eee;
        background: white;
        cursor: pointer;
        font-size: 16px;
        font-weight: 600;
        transition: 0.2s;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 10px;
    }

    .join-option-btn:hover {
        border-color: #FF6F61;
        background: #fff5f4;
        transform: translateY(-2px);
    }

    .join-option-btn.primary {
        background: linear-gradient(45deg, #FF6F61, #9B59B6);
        border: none;
        color: white;
    }

    .join-option-btn.primary:hover {
        background: linear-gradient(45deg, #ff5a4d, #8b4aa6);
        transform: translateY(-2px);
    }

    .join-option-btn.naver {
        background: #03C75A;
        border: none;
        color: white;
    }

    .join-option-btn.naver:hover {
        background: #02b350;
        transform: translateY(-2px);
    }

    .divider {
        display: flex;
        align-items: center;
        margin: 30px 0;
        color: #ccc;
        font-size: 14px;
    }

    .divider::before,
    .divider::after {
        content: '';
        flex: 1;
        height: 1px;
        background: #eee;
    }

    .divider::before {
        margin-right: 15px;
    }

    .divider::after {
        margin-left: 15px;
    }

    .login-link {
        text-align: center;
        margin-top: 25px;
        color: #888;
        font-size: 14px;
    }

    .login-link a {
        color: #FF6F61;
        text-decoration: none;
        font-weight: 600;
    }

    .login-link a:hover {
        text-decoration: underline;
    }
    .icon {
        width: 20px;
        height: 20px;
    }
</style>
</head>
<body>
<header>
	<c:if test="${!empty param.msg}">
	    <script>
	        alert("${param.msg}");
	    </script>
	</c:if>	
	
    <div class="logo">
    	<a href="/main/header">살래팔래</a>
    </div>
    <div class="menu-group">
        <button>중고 물품</button>
        <button>리뷰 피드</button>
        <button>나눔</button>
    </div>

	<!-- 로그인 X -->
	<sec:authorize access="isAnonymous()">  
	    <div class="auth-group">
	        <a href="/member/login"><button class="auth-login">로그인</button></a>
	        <a href="/member/joinChoice"><button class="auth-join">회원가입</button></a>
	    </div>
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
</header>