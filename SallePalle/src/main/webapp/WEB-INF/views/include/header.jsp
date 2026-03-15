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

<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
<title>Insert title here</title>
<style>
	/* 공통 */
	a {
		text-decoration: none;   /* 밑줄 제거 */
	    color: inherit;          /* 부모 색상 그대로 사용 */
	    font: inherit;           /* 부모 폰트 그대로 */
	}
	
	.preview-img {
	    width: 150px;
	    height: 150px;
	    border-radius: 50%;
	    border: 1px solid #ddd;
	    object-fit: cover;
	}
	
	.icon {
        width: 20px;
        height: 20px;
    }
    
   	.ok { color: blue !important; font-size: 13px; }
    .no { color: red !important; font-size: 13px; }
    .hint { color: green !important; font-size: 13px; }

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
        /* justify-content: space-between; */
        padding: 0 430px;
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
	
	/* header.jsp - 로그인 후 유저 정보 */
    .user-info-group {
        display: flex;
        align-items: center;
        gap: 25px;
        padding: 4px 15px;
        background: #fbfbfc;
        border-radius: 25px;
        cursor: pointer;
    }

    .user-profile-img {
        width: 45px;
        height: 45px;
        border-radius: 50%;
        object-fit: cover;
        border: 2px solid #fff;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }

    .user-nickname {
        font-size: 15px;
        font-weight: 600;
        color: #333;
        min-width: 60px;
    }

    .user-points {
        display: flex;
        align-items: center;
        gap: 8px;
        padding: 6px 12px;
        background: white;
        border-radius: 15px;
        font-size: 13px;
        color: #666;
        white-space: nowrap;
    }

    .user-points strong {
        color: #FF6F61;
        font-weight: 700;
        font-size: 14px;
    }

    .btn-charge {
        width: 22px;
        height: 22px;
        border-radius: 50%;
        background: linear-gradient(135deg, #FF6F61, #ff8a7d);
        border: none;
        color: white;
        font-size: 14px;
        font-weight: 700;
        line-height: 1;
        cursor: pointer;
        display: flex;
        align-items: center;
        justify-content: center;
        transition: 0.2s;
        flex-shrink: 0;
    }

    .btn-charge:hover {
        transform: scale(1.15);
        box-shadow: 0 2px 6px rgba(255, 111, 97, 0.4);
    }

    .user-mileage {
        display: flex;
        align-items: center;
        gap: 8px;
        padding: 6px 12px;
        background: white;
        border-radius: 15px;
        font-size: 13px;
        color: #666;
        white-space: nowrap;
    }

    .user-mileage strong {
        color: #9B59B6;
        font-weight: 700;
        font-size: 14px;
    }

    .btn-charge.mileage {
        background: linear-gradient(135deg, #9B59B6, #b376d1);
    }

    .btn-charge.mileage:hover {
        box-shadow: 0 2px 6px rgba(155, 89, 182, 0.4);
    }

    .btn-logout {
        padding: 8px 16px;
        border-radius: 15px;
        border: 1px solid #ddd;
        background: white;
        cursor: pointer;
        font-weight: 500;
        font-size: 14px;
        transition: 0.2s;
        white-space: nowrap;
    }

    .btn-logout:hover {
        background: #fff5f4;
        border-color: #FF6F61;
        color: #FF6F61;
    }
    
    /* header.jsp - 3등분 레이아웃 */
	.header-col {
	    flex: 1;
	    display: flex;
	    align-items: center;
	}
	
	.header-col.center {
	    justify-content: center;
	    padding-right: 72px;
	}
	
	.header-col.right {
	    justify-content: flex-end;
	}
	
	.header-col.left {
	    padding-left: 29px;
	}
	
	/* header.jps - 알림 아이콘 + 뱃지 */
	.notification-area {
	    position: relative;
	    margin-right: 10px;
	}
	
	.bell-icon {
	    width: 22px;
	    height: 22px;
	    cursor: pointer;
	}
	
	.notify-badge {
	    position: absolute;
	    top: -3px;
	    right: -3px;
	    width: 10px;
	    height: 10px;
	    background: red;
	    border-radius: 50%;
	    border: 1px solid white;
	}

	/* 드롭다운 관련 CSS */
	.user-dropdown {
	    position: relative;
	}

	.dropdown-arrow {
	    font-size: 10px;
	    color: #999;
	    transition: transform 0.3s;
	    margin-left: 5px;
	}

	.user-dropdown.active .dropdown-arrow {
	    transform: rotate(180deg);
	}

	.dropdown-menu {
	    position: absolute;
	    top: calc(100% + 10px);
	    right: 0;
	    width: 240px;
	    background: white;
	    border-radius: 12px;
	    box-shadow: 0 4px 20px rgba(0,0,0,0.15);
	    opacity: 0;
	    visibility: hidden;
	    transform: translateY(-10px);
	    transition: all 0.3s;
	    z-index: 1000;
	}

	.user-dropdown.active .dropdown-menu {
	    opacity: 1;
	    visibility: visible;
	    transform: translateY(0);
	}

	.dropdown-header {
	    padding: 20px;
	    border-bottom: 1px solid #f0f0f0;
	    text-align: center;
	}

	.dropdown-header .user-name {
	    font-size: 16px;
	    font-weight: 600;
	    color: #333;
	    margin-bottom: 5px;
	}

	.dropdown-header .user-email {
	    font-size: 12px;
	    color: #999;
	}

	.dropdown-stats {
	    display: flex;
	    padding: 15px;
	    border-bottom: 1px solid #f0f0f0;
	}

	.stat-item {
	    flex: 1;
	    text-align: center;
	}

	.stat-label {
	    font-size: 11px;
	    color: #999;
	    margin-bottom: 5px;
	}

	.stat-value {
	    font-size: 15px;
	    font-weight: 600;
	    color: #FF6F61;
	}

	.dropdown-item {
	    display: flex;
	    align-items: center;
	    gap: 12px;
	    padding: 12px 20px;
	    color: #333;
	    text-decoration: none;
	    font-size: 14px;
	    transition: background 0.2s;
	}

	.dropdown-item:hover {
	    background: #f8f9fa;
	}

	.dropdown-item-icon {
	    font-size: 18px;
	    width: 20px;
	    text-align: center;
	}

	.dropdown-logout {
	    border-top: 1px solid #f0f0f0;
	}

	.logout-btn-dropdown {
	    background: none;
	    border: none;
	    width: 100%;
	    text-align: left;
	    cursor: pointer;
	    font-family: inherit;
	    padding: 0;
	}

	.dropdown-logout .dropdown-item {
	    color: #FF6F61;
	    font-weight: 500;
	}

	/* login.jsp */
	input[type="image"] {
		width: 300px;
	}
    
    .main-login {
        margin-top: 70px;
        min-height: calc(100vh - 140px);
        display: flex;
        align-items: center;
        justify-content: center;
        padding: 40px 20px;
        background: #fbfbfc;
    }

    .login-container {
        width: 100%;
        max-width: 480px;
        background: white;
        border-radius: 16px;
        padding: 50px 40px;
        box-shadow: 0 2px 12px rgba(0,0,0,0.1);
    }

    .login-title {
        text-align: center;
        font-size: 28px;
        font-weight: 700;
        margin-bottom: 12px;
        color: #333;
    }
    
    .login-inputs {
	    margin-bottom: 30px;
	}
	
	.login-label {
	    display: block;
	    font-size: 14px;
	    font-weight: 600;
	    color: #555;
	    margin-bottom: 8px;
	    margin-top: 15px;
	}
	
	.login-inputs input[type="text"],
	.login-inputs input[type="password"] {
	    width: 100%;
	    padding: 14px 18px;
	    border: 2px solid #e0e0e0;
	    border-radius: 12px;
	    font-size: 15px;
	    transition: all 0.3s ease;
	    box-sizing: border-box;
	    background-color: #f8f9fa;
	}
	
	.login-inputs input[type="text"]:focus,
	.login-inputs input[type="password"]:focus {
	    outline: none;
	    border-color: #667eea;
	    background-color: white;
	    box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
	}
	
	.login-inputs input::placeholder {
	    color: #aaa;
	}
    
    .login-options {
        display: flex;
        flex-direction: column;
        gap: 16px;
    }

    .login-option-btn {
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

    .login-option-btn:hover {
        border-color: #FF6F61;
        background: #fff5f4;
        transform: translateY(-2px);
    }

    .login-option-btn.primary {
        background: linear-gradient(45deg, #FF6F61, #9B59B6);
        border: none;
        color: white;
    }

    .login-option-btn.primary:hover {
        background: linear-gradient(45deg, #ff5a4d, #8b4aa6);
        transform: translateY(-2px);
    }

    .login-option-btn.naver {
        background: #03C75A;
        border: none;
        color: white;
    }

    .login-option-btn.naver:hover {
        background: #02b350;
        transform: translateY(-2px);
    }
    
    .login-divider {
        display: flex;
        align-items: center;
        margin: 5px 0;
        color: #ccc;
        font-size: 14px;
    }

    .login-divider::before,
    .login-divider::after {
        content: '';
        flex: 1;
        height: 1px;
        background: #eee;
    }

    .login-divider::before {
        margin-right: 15px;
    }

    .login-divider::after {
        margin-left: 15px;
    }
    
    .login-footMenu {
        text-align: center;
        font-size: 15px;
        color: #888;
        margin-bottom: 40px;
    }
    
    /* home.jsp */
	.main-inner {
	    max-width: 1200px;
	    margin: 0 auto;
	    padding: 140px 20px 60px;
	}
	
	/* 타이틀 */
	.home-title {
	    text-align: center;
	    font-size: 42px;
	    font-weight: 700;
	    color: #333;
	    margin-bottom: 50px;
	    line-height: 1.4;
	}
	
	.home-subtitle {
	    text-align: center;
	    font-size: 18px;
	    color: #666;
	    margin-bottom: 40px;
	    font-weight: 500;
	}
	
	/* 검색창 */
	.search-box {
	    max-width: 700px;
	    margin: 0 auto 60px;
	}
	
	.search-box form {
	    position: relative;
	    display: flex;
	    align-items: center;
	    background: white;
	    border: 2px solid #ddd;
	    border-radius: 30px;
	    overflow: hidden;
	    transition: all 0.3s;
	}
	
	.search-box form:focus-within {
	    border-color: #FF6F61;
	    box-shadow: 0 0 0 4px rgba(255, 111, 97, 0.1);
	}
	
	.search-box input[type="text"] {
	    flex: 1;
	    padding: 18px 24px;
	    border: none;
	    font-size: 16px;
	    outline: none;
	}
	
	.search-box button {
	    padding: 18px 40px;
	    background: linear-gradient(135deg, #FF6F61, #9B59B6);
	    border: none;
	    color: white;
	    font-size: 16px;
	    font-weight: 600;
	    cursor: pointer;
	    transition: all 0.3s;
	}
	
	.search-box button:hover {
	    background: linear-gradient(135deg, #e55d50, #8a4ba3);
	}
	
	/* 카테고리 */
	.category-section {
	    margin-bottom: 80px;
	}
	
	.category {
	    display: flex;
	    gap: 15px;
	    overflow-x: auto;
	    padding: 10px 0;
	    scrollbar-width: thin;
	    scrollbar-color: #ddd transparent;
	}
	
	.category::-webkit-scrollbar {
	    height: 6px;
	}
	
	.category::-webkit-scrollbar-track {
	    background: transparent;
	}
	
	.category::-webkit-scrollbar-thumb {
	    background: #ddd;
	    border-radius: 3px;
	}
	
	.category::-webkit-scrollbar-thumb:hover {
	    background: #ccc;
	}
	
	.category a {
	    display: flex;
	    flex-direction: column;
	    align-items: center;
	    justify-content: center;
	    min-width: 120px;
	    padding: 25px 20px;
	    background: white;
	    border: 2px solid #f0f0f0;
	    border-radius: 16px;
	    text-decoration: none;
	    color: #333;
	    font-size: 14px;
	    font-weight: 600;
	    transition: all 0.3s;
	    position: relative;
	    white-space: nowrap;
	}
	
	.category a:before {
	    content: '🛍️';
	    font-size: 36px;
	    margin-bottom: 12px;
	}
	
	.category a:nth-child(1):before { content: '📚'; }
	.category a:nth-child(2):before { content: '🏠'; }
	.category a:nth-child(3):before { content: '🪑'; }
	.category a:nth-child(4):before { content: '👕'; }
	.category a:nth-child(5):before { content: '🎮'; }
	.category a:nth-child(6):before { content: '⚽'; }
	.category a:nth-child(7):before { content: '🍎'; }
	.category a:nth-child(8):before { content: '✈️'; }
	.category a:nth-child(9):before { content: '💻'; }
	.category a:nth-child(10):before { content: '🎪'; }
	.category a:nth-child(11):before { content: '📦'; }
	
	.category a:hover {
	    border-color: #FF6F61;
	    transform: translateY(-4px);
	    box-shadow: 0 6px 20px rgba(255, 111, 97, 0.2);
	}
	
	/* 섹션 타이틀 */
	.section-header {
	    margin-bottom: 30px;
	}
	
	.section-title {
	    font-size: 28px;
	    font-weight: 700;
	    color: #333;
	    margin-bottom: 8px;
	    padding-left: 12px;
	    border-left: 4px solid #FF6F61;
	}
	
	.section-subtitle {
	    font-size: 15px;
	    color: #999;
	    padding-left: 16px;
	}
	
	/* 스크롤 애니메이션 */
	.fade-in-section {
	    opacity: 0;
	    transform: translateY(30px);
	    transition: opacity 0.6s ease-out, transform 0.6s ease-out;
	}
	
	.fade-in-section.is-visible {
	    opacity: 1;
	    transform: translateY(0);
	}
	
	/* 상품 그리드 */
	.trade-grid {
	    display: grid;
	    grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
	    gap: 20px;
	    margin-bottom: 80px;
	}
	
	.trade-card {
	    background: white;
	    border-radius: 12px;
	    border: 1px solid #eee;
	    overflow: hidden;
	    transition: all 0.3s;
	    text-decoration: none;
	    color: inherit;
	    display: block;
	}
	
	.trade-card:hover {
	    transform: translateY(-5px);
	    box-shadow: 0 8px 24px rgba(0,0,0,0.12);
	}
	
	.trade-card-img {
	    width: 100%;
	    height: 200px;
	    background: #f5f5f5;
	    overflow: hidden;
	    position: relative;
	}
	
	.trade-card-img img {
	    width: 100%;
	    height: 100%;
	    object-fit: cover;
	}
	
	.trade-card-content {
	    padding: 16px;
	}
	
	.trade-card-title {
	    font-size: 15px;
	    font-weight: 600;
	    color: #333;
	    margin-bottom: 8px;
	    overflow: hidden;
	    text-overflow: ellipsis;
	    white-space: nowrap;
	}
	
	.trade-card-price {
	    font-size: 18px;
	    font-weight: 700;
	    color: #FF6F61;
	    margin-bottom: 8px;
	}
	
	.trade-card-meta {
	    display: flex;
	    align-items: center;
	    gap: 8px;
	    font-size: 13px;
	    color: #999;
	}
	
	.trade-card-recommend {
	    display: inline-flex;
	    align-items: center;
	    gap: 4px;
	    color: #FF6F61;
	    font-weight: 600;
	}
	
	/* 반응형 */
	@media (max-width: 768px) {
	    .home-header {
	        padding: 0 20px;
	    }
	    
	    .home-title {
	        font-size: 28px;
	    }
	    
	    .home-subtitle {
	        font-size: 15px;
	    }
	    
	    .category {
	        gap: 10px;
	        padding: 10px 0;
	    }
	    
	    .category a {
	        min-width: 90px;
	        padding: 20px 10px;
	        font-size: 13px;
	    }
	    
	    .category a:before {
	        font-size: 28px;
	        margin-bottom: 8px;
	    }
	    
	    .trade-grid {
	        grid-template-columns: repeat(auto-fill, minmax(160px, 1fr));
	        gap: 15px;
	    }
	    
	    .trade-card-img {
	        height: 160px;
	    }
	}
	/* read.jsp */
	.main-read {
	    margin-top: 70px;
	    min-height: calc(100vh - 140px);
	    display: flex;
	    justify-content: center;
	    padding: 40px 20px;
	    background: #fbfbfc;
	}
	
	.read-container {
	    width: 100%;
	    max-width: 800px;
	    background: white;
	    border-radius: 16px;
	    padding: 50px 40px;
	    box-shadow: 0 2px 12px rgba(0,0,0,0.1);
	    margin-bottom: 40px;
	}
	
	.read-title {
	    text-align: center;
	    font-size: 28px;
	    font-weight: 700;
	    margin-bottom: 12px;
	    color: #333;
	}
	
	.read-subtitle {
	    text-align: center;
	    font-size: 15px;
	    color: #888;
	    margin-bottom: 40px;
	}
	
	/* 프로필 섹션 */
	.read-profile-section {
	    display: flex;
	    flex-direction: column;
	    align-items: center;
	    margin-bottom: 40px;
	    padding-bottom: 30px;
	    border-bottom: 2px solid #f0f0f0;
	}
	
	.read-profile-img-wrapper {
	    position: relative;
	    margin-bottom: 20px;
	}
	
	.read-profile-img {
	    width: 150px;
	    height: 150px;
	    border-radius: 50%;
	    border: 4px solid #f0f0f0;
	    object-fit: cover;
	    box-shadow: 0 4px 12px rgba(0,0,0,0.1);
	}
	
	.read-profile-edit-btn {
	    display: flex;
	    align-items: center;
	    gap: 8px;
	    padding: 10px 20px;
	    background: linear-gradient(45deg, #FF6F61, #9B59B6);
	    border: none;
	    border-radius: 20px;
	    color: white;
	    font-size: 14px;
	    font-weight: 600;
	    cursor: pointer;
	    transition: 0.2s;
	    text-decoration: none;
	}
	
	.read-profile-edit-btn:hover {
	    transform: translateY(-2px);
	    box-shadow: 0 4px 12px rgba(255, 111, 97, 0.3);
	}
	
	/* 정보 카드 */
	.read-info-cards {
	    display: grid;
	    grid-template-columns: repeat(2, 1fr);
	    gap: 15px;
	    margin-bottom: 30px;
	}
	
	.read-info-card {
	    padding: 20px;
	    background: #f8f9fa;
	    border-radius: 12px;
	    border: 1px solid #e9ecef;
	    transition: 0.2s;
	}
	
	.read-info-card:hover {
	    background: #fff;
	    border-color: #FF6F61;
	    box-shadow: 0 2px 8px rgba(255, 111, 97, 0.1);
	}
	
	.read-info-card-wide {
	    grid-column: 1 / -1;
	}
	
	.read-info-label {
	    font-size: 13px;
	    color: #888;
	    margin-bottom: 8px;
	    font-weight: 500;
	}
	
	.read-info-value {
	    font-size: 16px;
	    color: #333;
	    font-weight: 600;
	}
	
	/* 버튼 그룹 */
	.read-button-group {
	    display: flex;
	    gap: 12px;
	    margin-top: 30px;
	}
	
	.read-btn {
	    flex: 1;
	    padding: 14px 20px;
	    border-radius: 10px;
	    font-size: 15px;
	    font-weight: 600;
	    cursor: pointer;
	    transition: 0.2s;
	    border: none;
	    text-align: center;
	    text-decoration: none;
	    display: inline-block;
	}
	
	.read-btn-primary {
	    background: linear-gradient(45deg, #FF6F61, #9B59B6);
	    color: white;
	}
	
	.read-btn-primary:hover {
	    transform: translateY(-2px);
	    box-shadow: 0 4px 12px rgba(255, 111, 97, 0.3);
	}
	
	.read-btn-secondary {
	    background: white;
	    color: #dc3545;
	    border: 1px solid #dc3545;
	}
	
	.read-btn-secondary:hover {
	    background: #dc3545;
	    color: white;
	}
	
	.read-btn-outline {
	    background: white;
	    color: #666;
	    border: 1px solid #ddd;
	}
	
	.read-btn-outline:hover {
	    background: #f8f8f8;
	    border-color: #FF6F61;
	    color: #FF6F61;
	}
	
	/* 모달 */
	.read-modal {
	    display: none;
	    position: fixed;
	    top: 0;
	    left: 0;
	    width: 100%;
	    height: 100%;
	    background: rgba(0,0,0,0.6);
	    justify-content: center;
	    align-items: center;
	    z-index: 999;
	}
	
	.read-modal-content {
	    background: white;
	    padding: 35px;
	    width: 400px;
	    border-radius: 16px;
	    box-shadow: 0 4px 20px rgba(0,0,0,0.15);
	}
	
	.read-modal-title {
	    font-size: 22px;
	    font-weight: 700;
	    color: #333;
	    margin: 0 0 10px 0;
	    text-align: center;
	}
	
	.read-modal-subtitle {
	    font-size: 14px;
	    color: #888;
	    margin-bottom: 25px;
	    text-align: center;
	}
	
	.read-modal-input {
	    width: 100%;
	    padding: 14px 18px;
	    border: 2px solid #e0e0e0;
	    border-radius: 10px;
	    font-size: 15px;
	    box-sizing: border-box;
	    margin-bottom: 20px;
	    transition: 0.2s;
	}
	
	.read-modal-input:focus {
	    outline: none;
	    border-color: #FF6F61;
	}
	
	.read-modal-buttons {
	    display: flex;
	    gap: 10px;
	}
	
	.read-modal-btn {
	    flex: 1;
	    padding: 12px;
	    border-radius: 8px;
	    font-size: 15px;
	    font-weight: 600;
	    cursor: pointer;
	    transition: 0.2s;
	    border: none;
	}
	
	.read-modal-btn-confirm {
	    background: #dc3545;
	    color: white;
	}
	
	.read-modal-btn-confirm:hover {
	    background: #c82333;
	}
	
	.read-modal-btn-cancel {
	    background: white;
	    color: #666;
	    border: 1px solid #ddd;
	}
	
	.read-modal-btn-cancel:hover {
	    background: #f8f8f8;
	}
	
	/* 반응형 */
	@media (max-width: 768px) {
	    .read-info-cards {
	        grid-template-columns: 1fr;
	    }
	    
	    .read-button-group {
	        flex-direction: column;
	    }
	}
	
	/* profileEdit.jsp */
	.main-profileEdit {
	    margin-top: 70px;
	    min-height: calc(100vh - 140px);
	    display: flex;
	    justify-content: center;
	    padding: 40px 20px;
	    background: #fbfbfc;
	}
	
	.profileEdit-container {
	    width: 100%;
	    max-width: 600px;
	    background: white;
	    border-radius: 16px;
	    padding: 50px 40px;
	    box-shadow: 0 2px 12px rgba(0,0,0,0.1);
	    margin-bottom: 40px;
	}
	
	.profileEdit-title {
	    text-align: center;
	    font-size: 28px;
	    font-weight: 700;
	    margin-bottom: 12px;
	    color: #333;
	}
	
	.profileEdit-subtitle {
	    text-align: center;
	    font-size: 15px;
	    color: #888;
	    margin-bottom: 40px;
	}
	
	/* 프로필 미리보기 섹션 */
	.profileEdit-preview-section {
	    display: flex;
	    flex-direction: column;
	    align-items: center;
	    margin-bottom: 30px;
	}
	
	.profileEdit-preview-wrapper {
	    position: relative;
	    width: 200px;
	    height: 200px;
	    margin-bottom: 20px;
	}
	
	.profileEdit-preview-img {
	    width: 100%;
	    height: 100%;
	    border-radius: 50%;
	    border: 4px solid #f0f0f0;
	    object-fit: cover;
	    box-shadow: 0 4px 16px rgba(0,0,0,0.1);
	}
	
	.profileEdit-preview-overlay {
	    position: absolute;
	    top: 0;
	    left: 0;
	    width: 208px;
	    height: 208px;
	    border-radius: 50%;
	    background: rgba(0,0,0,0.4);
	    display: flex;
	    align-items: center;
	    justify-content: center;
	    opacity: 0;
	    transition: 0.3s;
	}
	
	.profileEdit-preview-wrapper:hover .profileEdit-preview-overlay {
	    opacity: 1;
	}
	
	.profileEdit-camera-icon {
	    width: 50px;
	    height: 50px;
	}
	
	.profileEdit-cancel-btn {
	    padding: 8px 20px;
	    background: white;
	    border: 1px solid #ddd;
	    border-radius: 20px;
	    color: #666;
	    font-size: 14px;
	    font-weight: 600;
	    cursor: pointer;
	    transition: 0.2s;
	}
	
	.profileEdit-cancel-btn:hover {
	    background: #f8f8f8;
	    border-color: #FF6F61;
	    color: #FF6F61;
	}
	
	/* 파일 업로드 */
	.profileEdit-upload-section {
	    margin-bottom: 30px;
	}
	
	.profileEdit-upload-label {
	    display: flex;
	    align-items: center;
	    justify-content: center;
	    gap: 10px;
	    width: 556px;
	    padding: 20px;
	    border: 2px dashed #ddd;
	    border-radius: 12px;
	    background: #fafafa;
	    cursor: pointer;
	    transition: 0.2s;
	}
	
	.profileEdit-upload-label:hover {
	    border-color: #FF6F61;
	    background: #fff5f4;
	}
	
	.profileEdit-upload-label span {
	    font-size: 15px;
	    font-weight: 600;
	    color: #666;
	}
	
	.profileEdit-upload-label:hover span {
	    color: #FF6F61;
	}
	
	/* 버튼 그룹 */
	.profileEdit-button-group {
	    display: flex;
	    flex-direction: column;
	    gap: 12px;
	}
	
	.profileEdit-btn {
	    width: 100%;
	    padding: 14px 20px;
	    border-radius: 10px;
	    font-size: 15px;
	    font-weight: 600;
	    cursor: pointer;
	    transition: 0.2s;
	    border: none;
	    text-align: center;
	    text-decoration: none;
	    display: inline-block;
	}
	
	.profileEdit-btn-primary {
	    background: linear-gradient(45deg, #FF6F61, #9B59B6);
	    color: white;
	}
	
	.profileEdit-btn-primary:hover {
	    transform: translateY(-2px);
	    box-shadow: 0 4px 12px rgba(255, 111, 97, 0.3);
	}
	
	.profileEdit-btn-reset {
	    background: white;
	    color: #ffc107;
	    border: 1px solid #ffc107;
	}
	
	.profileEdit-btn-reset:hover {
	    background: #ffc107;
	    color: white;
	}
	
	.profileEdit-btn-outline {
		width: 559px;
	    background: white;
	    color: #666;
	    border: 1px solid #ddd;
	}
	
	.profileEdit-btn-outline:hover {
	    background: #f8f8f8;
	    border-color: #FF6F61;
	    color: #FF6F61;
	}
	
	/* update.jsp */
	.main-update {
	    margin-top: 70px;
	    min-height: calc(100vh - 140px);
	    display: flex;
	    justify-content: center;
	    padding: 40px 20px;
	}
	
	.update-container {
	    width: 100%;
	    max-width: 700px;
	    background: white;
	    border-radius: 16px;
	    padding: 50px 40px;
	    box-shadow: 0 2px 12px rgba(0,0,0,0.1);
	    margin-bottom: 40px;
	}
	
	.update-title {
	    text-align: center;
	    font-size: 28px;
	    font-weight: 700;
	    margin-bottom: 12px;
	    color: #333;
	}
	
	.update-subtitle {
	    text-align: center;
	    font-size: 15px;
	    color: #888;
	    margin-bottom: 40px;
	}
	
	/* 필드 */
	.update-field {
	    margin-bottom: 25px;
	}
	
	.update-label {
	    display: block;
	    font-size: 14px;
	    font-weight: 600;
	    color: #333;
	    margin-bottom: 8px;
	}
	
	/* 현재 이미지 */
	.update-image-current {
	    width: 100%;
	    height: 300px;
	    border-radius: 12px;
	    overflow: hidden;
	    margin-bottom: 15px;
	    border: 2px solid #f0f0f0;
	}
	
	.update-image-current img {
	    width: 100%;
	    height: 100%;
	    object-fit: cover;
	}
	
	/* 이미지 변경 버튼 */
	.update-image-upload {
	    margin-bottom: 15px;
	}
	
	.update-image-label {
	    display: flex;
	    align-items: center;
	    justify-content: center;
	    gap: 8px;
	    padding: 12px;
	    border: 1px solid #FF6F61;
	    border-radius: 8px;
	    background: white;
	    color: #FF6F61;
	    cursor: pointer;
	    transition: 0.2s;
	}
	
	.update-image-label:hover {
	    background: #fff5f4;
	}
	
	.update-image-label svg {
	    width: 20px;
	    height: 20px;
	}
	
	/* 새 이미지 미리보기 */
	.update-image-preview {
	    width: 100%;
	    height: 300px;
	    border-radius: 12px;
	    overflow: hidden;
	    border: 2px solid #FF6F61;
	}
	
	.update-image-preview img {
	    width: 100%;
	    height: 100%;
	    object-fit: cover;
	}
	
	/* 입력 필드 */
	.update-input {
	    width: 100%;
	    padding: 12px 15px;
	    border: 1px solid #ddd;
	    border-radius: 8px;
	    font-size: 14px;
	    box-sizing: border-box;
	    transition: 0.2s;
	}
	
	.update-input:focus {
	    outline: none;
	    border-color: #FF6F61;
	}
	
	.update-input-disabled {
	    background: #f8f9fa;
	    color: #999;
	    cursor: not-allowed;
	}
	
	.update-textarea {
	    width: 100%;
	    padding: 12px 15px;
	    border: 1px solid #ddd;
	    border-radius: 8px;
	    font-size: 14px;
	    box-sizing: border-box;
	    transition: 0.2s;
	    resize: vertical;
	    font-family: inherit;
	}
	
	.update-textarea:focus {
	    outline: none;
	    border-color: #FF6F61;
	}
	
	.update-select {
	    width: 100%;
	    padding: 12px 15px;
	    border: 1px solid #ddd;
	    border-radius: 8px;
	    font-size: 14px;
	    box-sizing: border-box;
	    transition: 0.2s;
	}
	
	.update-select:focus {
	    outline: none;
	    border-color: #FF6F61;
	}
	
	/* 단위 표시 */
	.update-input-with-unit {
	    position: relative;
	}
	
	.update-input-with-unit input {
	    padding-right: 40px;
	}
	
	.update-input-unit {
	    position: absolute;
	    right: 15px;
	    top: 50%;
	    transform: translateY(-50%);
	    font-size: 14px;
	    font-weight: 600;
	    color: #FF6F61;
	}
	
	.update-input-unitM {
	    position: absolute;
	    right: 15px;
	    top: 50%;
	    transform: translateY(-50%);
	    font-size: 14px;
	    font-weight: 600;
	    color: #9B59B6;
	}
	
	/* 주소 검색 */
	.update-input-row {
	    display: flex;
	    gap: 10px;
	}
	
	.update-input-row input {
	    flex: 1;
	}
	
	.update-btn-search {
	    padding: 12px 20px;
	    background: white;
	    border: 1px solid #ddd;
	    border-radius: 8px;
	    cursor: pointer;
	    font-size: 14px;
	    font-weight: 600;
	    white-space: nowrap;
	    transition: 0.2s;
	}
	
	.update-btn-search:hover {
	    background: #f8f8f8;
	    border-color: #FF6F61;
	    color: #FF6F61;
	}
	
	.update-field-notice {
	    font-size: 12px;
	    color: #999;
	    margin-top: 5px;
	    font-style: italic;
	}
	
	/* 버튼 그룹 */
	.update-button-group {
	    display: flex;
	    gap: 12px;
	    margin-top: 40px;
	}
	
	.update-btn {
	    flex: 1;
	    padding: 14px 20px;
	    border-radius: 10px;
	    font-size: 15px;
	    font-weight: 600;
	    cursor: pointer;
	    transition: 0.2s;
	    border: none;
	    text-align: center;
	    text-decoration: none;
	    display: inline-block;
	}
	
	.update-btn-primary {
	    background: linear-gradient(135deg, #FF6F61, #9B59B6);
	    color: white;
	}
	
	.update-btn-primary:hover {
	    transform: translateY(-2px);
	    box-shadow: 0 4px 12px rgba(255, 111, 97, 0.3);
	}
	
	.update-btn-outline {
	    background: white;
	    color: #666;
	    border: 1px solid #ddd;
	}
	
	.update-btn-outline:hover {
	    background: #f8f8f8;
	    border-color: #FF6F61;
	    color: #FF6F61;
	}
	
	/* 반응형 */
	@media (max-width: 768px) {
	    .update-button-group {
	        flex-direction: column;
	    }
	    
	    .update-image-current,
	    .update-image-preview {
	        height: 200px;
	    }
	}
    
    /* joinChoice.jsp */
    .main-joinChoice {
        margin-top: 70px;
        min-height: calc(100vh - 140px);
        display: flex;
        align-items: center;
        justify-content: center;
        padding: 40px 20px;
        background: #fbfbfc;
    }

    .joinChoice-container {
        width: 100%;
        max-width: 480px;
        background: white;
        border-radius: 16px;
        padding: 50px 40px;
        box-shadow: 0 2px 12px rgba(0,0,0,0.1);
    }

    .joinChoice-title {
        text-align: center;
        font-size: 28px;
        font-weight: 700;
        margin-bottom: 12px;
        color: #333;
    }

    .joinChoice-subtitle {
        text-align: center;
        font-size: 15px;
        color: #888;
        margin-bottom: 40px;
    }

    .joinChoice-options {
        display: flex;
        flex-direction: column;
        gap: 16px;
    }

    .joinChoice-option-btn {
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

    .joinChoice-option-btn:hover {
        border-color: #FF6F61;
        background: #fff5f4;
        transform: translateY(-2px);
    }

    .joinChoice-option-btn.primary {
        background: linear-gradient(45deg, #FF6F61, #9B59B6);
        border: none;
        color: white;
    }

    .joinChoice-option-btn.primary:hover {
        background: linear-gradient(45deg, #ff5a4d, #8b4aa6);
        transform: translateY(-2px);
    }

    .joinChoice-option-btn.naver {
        background: #03C75A;
        border: none;
        color: white;
    }

    .joinChoice-option-btn.naver:hover {
        background: #02b350;
        transform: translateY(-2px);
    }

    .joinChoice-divider {
        display: flex;
        align-items: center;
        margin: 30px 0;
        color: #ccc;
        font-size: 14px;
    }

    .joinChoice-divider::before,
    .joinChoice-divider::after {
        content: '';
        flex: 1;
        height: 1px;
        background: #eee;
    }

    .joinChoice-divider::before {
        margin-right: 15px;
    }

    .joinChoice-divider::after {
        margin-left: 15px;
    }

    .joinChoice-link {
        text-align: center;
        margin-top: 25px;
        color: #888;
        font-size: 14px;
    }

    .joinChoice-link a {
        color: #FF6F61;
        text-decoration: none;
        font-weight: 600;
    }

    .joinChoice-link a:hover {
        text-decoration: underline;
    }
    
    /* join.jsp */
    .main-join {
        margin-top: 70px;
        min-height: calc(100vh - 140px);
        display: flex;
        justify-content: center;
        padding: 40px 20px;
        background: #fbfbfc;
    }

    .join-container {
        width: 100%;
        max-width: 600px;
        background: white;
        border-radius: 16px;
        padding: 50px 40px;
        box-shadow: 0 2px 12px rgba(0,0,0,0.1);
        margin-bottom: 40px;
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

    .join-field {
        margin-bottom: 25px;
    }

    .join-label {
        display: block;
        font-size: 14px;
        font-weight: 600;
        color: #333;
        margin-bottom: 8px;
    }

    .join-input {
        width: 100%;
        padding: 12px 15px;
        border: 1px solid #ddd;
        border-radius: 8px;
        font-size: 14px;
        box-sizing: border-box;
        transition: 0.2s;
    }

    .join-input:focus {
        outline: none;
        border-color: #FF6F61;
    }

    .join-select {
        width: 100%;
        padding: 12px 15px;
        border: 1px solid #ddd;
        border-radius: 8px;
        font-size: 14px;
        box-sizing: border-box;
        transition: 0.2s;
    }

    .join-select:focus {
        outline: none;
        border-color: #FF6F61;
    }

    .join-input-row {
        display: flex;
        gap: 10px;
    }

    .join-input-row input {
        flex: 1;
    }

    .join-btn-check {
        padding: 12px 20px;
        background: white;
        border: 1px solid #ddd;
        border-radius: 8px;
        cursor: pointer;
        font-size: 14px;
        font-weight: 600;
        white-space: nowrap;
        transition: 0.2s;
    }

    .join-btn-check:hover {
        background: #f8f8f8;
        border-color: #FF6F61;
        color: #FF6F61;
    }

    .join-radio-group {
        display: flex;
        gap: 20px;
    }

    .join-radio-label {
        display: flex;
        align-items: center;
        gap: 6px;
        font-weight: 400;
        cursor: pointer;
    }

    .join-radio-label input[type="radio"] {
        cursor: pointer;
    }

    .join-birth-group {
        display: flex;
        gap: 10px;
    }

    .join-birth-group select {
        flex: 1;
    }

    .join-checkbox-group {
        display: flex;
        flex-direction: column;
        gap: 12px;
    }

    .join-checkbox-label {
        display: flex;
        align-items: center;
        gap: 8px;
        font-weight: 400;
        cursor: pointer;
        font-size: 14px;
    }

    .join-checkbox-label input[type="checkbox"] {
        cursor: pointer;
        width: 18px;
        height: 18px;
    }
    
    .join-submit-btn {
        width: 100%;
        padding: 16px;
        background: linear-gradient(45deg, #FF6F61, #9B59B6);
        border: none;
        border-radius: 10px;
        color: white;
        font-size: 16px;
        font-weight: 700;
        cursor: pointer;
        transition: 0.2s;
        margin-top: 30px;
    }

    .join-submit-btn:hover:not(:disabled) {
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(255, 111, 97, 0.3);
    }

    .join-submit-btn:disabled {
        background: #ddd;
        cursor: not-allowed;
    }

    #idModal {
        display: none;
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0,0,0,0.6);
        justify-content: center;
        align-items: center;
        z-index: 999;
    }

    .join-modal-content {
        background: white;
        padding: 30px;
        width: 320px;
        border-radius: 12px;
        text-align: center;
        box-shadow: 0 4px 20px rgba(0,0,0,0.15);
    }

    .join-modal-content h3 {
        margin: 0 0 20px 0;
        font-size: 16px;
        color: #333;
    }

    .join-modal-btn {
        padding: 10px 30px;
        background: #FF6F61;
        border: none;
        border-radius: 8px;
        color: white;
        font-weight: 600;
        cursor: pointer;
    }

    .join-modal-btn:hover {
        background: #ff5a4d;
    }
    
    .join-login-link {
        text-align: center;
        margin-top: 20px;
        color: #888;
        font-size: 14px;
    }

    .join-login-link a {
        color: #FF6F61;
        text-decoration: none;
        font-weight: 600;
    }

    .join-login-link a:hover {
        text-decoration: underline;
    }
    
    /* findId */
    .main-findId {
        margin-top: 10px;
        margin-bottom: 0px;
        min-height: calc(100vh - 140px);
        display: flex;
        align-items: center;
        justify-content: center;
        padding: 30px 20px;
        background: #fbfbfc;
    }

    .findId-container {
        width: 100%;
        max-width: 480px;
        background: white;
        border-radius: 16px;
        padding: 50px 40px;
        box-shadow: 0 2px 12px rgba(0,0,0,0.1);
    }

    .findId-title {
        text-align: center;
        font-size: 28px;
        font-weight: 700;
        margin-bottom: 12px;
        color: #333;
    }

    .findId-subtitle {
        text-align: center;
        font-size: 15px;
        color: #888;
        margin-bottom: 40px;
    }

/*     .findId-msg {
        padding: 12px 15px;
        background: #fff5f4;
        border: 1px solid #ffddda;
        border-radius: 8px;
        color: #FF6F61;
        font-size: 14px;
        margin-bottom: 20px;
        text-align: center;
    } */

    .findId-field {
        margin-bottom: 25px;
    }

    .findId-label {
        display: block;
        font-size: 14px;
        font-weight: 600;
        color: #333;
        margin-bottom: 8px;
    }

    .findId-input {
        width: 100%;
        padding: 14px 18px;
        border: 2px solid #e0e0e0;
        border-radius: 12px;
        font-size: 15px;
        box-sizing: border-box;
        transition: 0.3s;
        background-color: #f8f9fa;
    }

    .findId-input:focus {
        outline: none;
        border-color: #FF6F61;
        background-color: white;
        box-shadow: 0 0 0 4px rgba(255, 111, 97, 0.1);
    }

    .findId-submit-btn {
        width: 100%;
        padding: 16px;
        background: linear-gradient(45deg, #FF6F61, #9B59B6);
        border: none;
        border-radius: 10px;
        color: white;
        font-size: 16px;
        font-weight: 700;
        cursor: pointer;
        transition: 0.2s;
        margin-bottom: 20px;
    }

    .findId-submit-btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(255, 111, 97, 0.3);
    }

    .findId-divider {
        display: flex;
        align-items: center;
        margin: 30px 0;
        color: #ccc;
        font-size: 14px;
    }

    .findId-divider::before,
    .findId-divider::after {
        content: '';
        flex: 1;
        height: 1px;
        background: #eee;
    }

    .findId-divider::before {
        margin-right: 15px;
    }

    .findId-divider::after {
        margin-left: 15px;
    }

    .findId-links {
        display: flex;
        gap: 10px;
    }

    .findId-link-btn {
        flex: 1;
        padding: 14px;
        background: white;
        border: 1px solid #ddd;
        border-radius: 10px;
        color: #666;
        font-size: 14px;
        font-weight: 600;
        cursor: pointer;
        transition: 0.2s;
        text-align: center;
    }

    .findId-link-btn:hover {
        background: #f8f8f8;
        border-color: #FF6F61;
        color: #FF6F61;
    }
    
    /* chargePoint.jsp */
    .main-charge {
        margin-top: 10px;
        margin-bottom: 0px;
        min-height: calc(100vh - 140px);
        display: flex;
        align-items: center;
        justify-content: center;
        padding: 30px 20px;
        background: #fbfbfc;
    }
	.charge-container {
 		width: 100%;
        max-width: 480px;
        background: white;
        border-radius: 16px;
        padding: 50px 40px;
        box-shadow: 0 2px 12px rgba(0,0,0,0.1);
    }
    .charge-title {
        font-size: 26px;
        font-weight: bold;
        margin-bottom: 20px;
        text-align: center;
    }
    .charge-item {
        display: flex;
        justify-content: space-between;
        align-items: center;
        border: 1px solid #ececec;
        padding: 15px;
        margin-bottom: 12px;
        border-radius: 10px;
        cursor: pointer;
    }
    .charge-item:hover {
        background: #fafafa;
    }
    .charge-left {
        display: flex;
        align-items: center;
        gap: 10px;
    }
    .charge-left img {
        width: 50px;
        height: 50px;
    }
    .charge-right {
        font-size: 18px;
        font-weight: bold;
        color: #ff7f00;
    }
    
    /* footer.jsp */
    footer {
        padding: 30px 0;
        text-align: center;
        color: #888;
        font-size: 13px;
        background: white;
        border-top: 1px solid #eee;
    }
    
    /* paymentHistory.jsp */
	.main-paymentHistory {
	    margin-top: 50px;
	    min-height: calc(100vh - 140px);
	    display: flex;
	    justify-content: center;
	    padding: 30px 20px;
	    background: #fbfbfc;
	}
	
	.paymentHistory-container {
	    width: 100%;
	    max-width: 1000px;
	    background: white;
	    border-radius: 16px;
	    padding: 50px 40px;
	    box-shadow: 0 2px 12px rgba(0,0,0,0.1);
	    margin-bottom: 40px;
	}
	
	.paymentHistory-title {
	    text-align: center;
	    font-size: 28px;
	    font-weight: 700;
	    margin-bottom: 12px;
	    color: #333;
	}
	
	.paymentHistory-subtitle {
	    text-align: center;
	    font-size: 15px;
	    color: #888;
	    margin-bottom: 40px;
	}
	
	/* 필터 버튼 */
	.paymentHistory-filter {
	    display: flex;
	    gap: 10px;
	    justify-content: center;
	    margin-bottom: 30px;
	}
	
	.paymentHistory-filter-btn {
	    padding: 10px 24px;
	    border: 2px solid #e0e0e0;
	    border-radius: 20px;
	    background: white;
	    color: #666;
	    font-size: 14px;
	    font-weight: 600;
	    cursor: pointer;
	    transition: 0.2s;
	}
	
	.paymentHistory-filter-btn:hover {
	    border-color: #FF6F61;
	    color: #FF6F61;
	}
	
	.paymentHistory-filter-btn.active {
	    background: linear-gradient(135deg, #FF6F61, #9B59B6);
	    border-color: transparent;
	    color: white;
	}
	
	/* 테이블 */
	.paymentHistory-table-wrapper {
	    overflow-x: auto;
	    border-radius: 12px;
	    border: 1px solid #e9ecef;
	}
	
	.paymentHistory-table {
	    width: 100%;
	    border-collapse: collapse;
	}
	
	.paymentHistory-table thead {
	    background: #f8f9fa;
	}
	
	.paymentHistory-table thead th {
	    padding: 15px 20px;
	    text-align: left;
	    font-size: 14px;
	    font-weight: 600;
	    color: #333;
	    border-bottom: 2px solid #e9ecef;
	}
	
	.paymentHistory-table tbody td {
	    padding: 18px 20px;
	    font-size: 14px;
	    color: #333;
	    border-bottom: 1px solid #f0f0f0;
	}
	
	.paymentHistory-row:hover {
	    background: #f8f9fa;
	}
	
	/* 배지 */
	.paymentHistory-badge {
	    display: inline-block;
	    padding: 5px 12px;
	    border-radius: 12px;
	    font-size: 12px;
	    font-weight: 600;
	    white-space: nowrap;
	}
	
	.paymentHistory-badge.charge {
	    background: #d1ecf1;
	    color: #0c5460;
	}
	
	.paymentHistory-badge.use {
	    background: #f8d7da;
	    color: #721c24;
	}
	
	.paymentHistory-badge.earn {
	    background: #d4edda;
	    color: #155724;
	}
	
	.paymentHistory-badge.gray {
	    background: #e2e3e5;
	    color: #6c757d;
	}
	
	/* 금액 */
	.paymentHistory-amount {
	    font-weight: 700;
	    font-size: 15px;
	}
	
	.paymentHistory-amount.plus {
	    color: #28a745;
	}
	
	.paymentHistory-amount.minus {
	    color: #dc3545;
	}
	
	.paymentHistory-memo {
	    color: #666;
	}
	
	/* 페이지네이션 */
	.paymentHistory-pagination {
	    display: flex;
	    justify-content: center;
	    gap: 8px;
	    margin-top: 30px;
	}
	
	.paymentHistory-page-btn {
	    display: block;
	    padding: 8px 14px;
	    border: 1px solid #ddd;
	    border-radius: 6px;
	    color: #333;
	    text-decoration: none;
	    font-size: 14px;
	    transition: 0.2s;
	}
	
	.paymentHistory-page-btn:hover {
	    background: #FF6F61;
	    color: white;
	    border-color: #FF6F61;
	}
	
	.paymentHistory-page-btn.active {
	    background: linear-gradient(135deg, #FF6F61, #9B59B6);
	    color: white;
	    border-color: transparent;
	    font-weight: 700;
	}
	
	/* 반응형 */
	@media (max-width: 768px) {
	    .paymentHistory-filter {
	        flex-wrap: wrap;
	    }
	    
	    .paymentHistory-table-wrapper {
	        overflow-x: scroll;
	    }
	}
	
	/* saleTradeList.jsp */
	.main-saleTradeList {
	    margin-top: 100px;
	    width: 100%;
	    display: flex;
	    justify-content: center;
	    padding: 0 20px 40px;
	}
	
	.saleTradeList-container {
	    width: 100%;
	    max-width: 1200px;
	}
	
	/* 통합 검색창 */
	.saleTradeList-search-box {
	    position: relative;
	    display: flex;
	    justify-content: center;
	    margin-bottom: 25px;
	}
	
	.saleTradeList-search-wrapper {
	    width: 80%;
	    display: flex;
	    align-items: center;
	    background: white;
	    border: 2px solid #ddd;
	    border-radius: 30px;
	    overflow: hidden;
	    transition: all 0.3s;
	}
	
	.saleTradeList-search-wrapper:focus-within {
	    border-color: #FF6F61;
	    box-shadow: 0 0 0 4px rgba(255, 111, 97, 0.1);
	}
	
	.saleTradeList-search-select {
	    padding: 14px 20px;
	    border: none;
	    background: transparent;
	    font-size: 15px;
	    font-weight: 600;
	    color: #666;
	    cursor: pointer;
	    outline: none;
	    border-right: 1px solid #eee;
	}
	
	.saleTradeList-search-wrapper input {
	    flex: 1;
	    padding: 14px 20px;
	    border: none;
	    font-size: 15px;
	    outline: none;
	}
	
	.btn-search {
	    padding: 14px 30px;
	    background: linear-gradient(135deg, #FF6F61, #9B59B6);
	    border: none;
	    color: white;
	    font-size: 15px;
	    font-weight: 600;
	    cursor: pointer;
	    transition: all 0.3s;
	}
	
	.btn-search:hover {
	    background: linear-gradient(135deg, #e55d50, #8a4ba3);
	}
	
	/* 카테고리 탭 */
	.saleTradeList-category {
	    display: flex;
	    gap: 12px;
	    overflow-x: auto;
	    padding-bottom: 5px;
	    margin-bottom: 30px;
	}
	
	.saleTradeList-category::-webkit-scrollbar {
	    height: 4px;
	}
	
	.saleTradeList-category::-webkit-scrollbar-thumb {
	    background: #ddd;
	    border-radius: 2px;
	}
	
	.saleTradeList-category-btn {
	    padding: 10px 20px;
	    border-radius: 20px;
	    border: 1px solid #ddd;
	    background: white;
	    cursor: pointer;
	    font-size: 14px;
	    white-space: nowrap;
	    transition: 0.2s;
	    font-weight: 500;
	}
	
	.saleTradeList-category-btn:hover {
	    border-color: #FF6F61;
	    color: #FF6F61;
	}
	
	.saleTradeList-category-btn.active {
	    background: linear-gradient(135deg, #FF6F61, #9B59B6);
	    border-color: transparent;
	    color: white;
	}
	
	/* 상품 등록 버튼 */
	.saleTradeList-register-section {
	    display: flex;
	    justify-content: flex-end;
	    margin-bottom: 25px;
	}
	
	.btn-register-product {
	    display: inline-flex;
	    align-items: center;
	    gap: 8px;
	    padding: 14px 28px;
	    background: linear-gradient(135deg, #FF6F61, #9B59B6);
	    color: white;
	    text-decoration: none;
	    border-radius: 12px;
	    font-size: 15px;
	    font-weight: 700;
	    transition: all 0.3s;
	    box-shadow: 0 4px 12px rgba(255, 111, 97, 0.3);
	}
	
	.btn-register-product:hover {
	    transform: translateY(-2px);
	    box-shadow: 0 6px 20px rgba(255, 111, 97, 0.4);
	}
	
	.btn-register-product svg {
	    width: 20px;
	    height: 20px;
	}
	
	/* 물품 그리드 */
	.saleTradeList-grid {
	    display: grid;
	    grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
	    gap: 20px;
	}
	
	.saleTradeList-card {
	    background: white;
	    border-radius: 12px;
	    border: 1px solid #eee;
	    overflow: hidden;
	    transition: 0.2s;
	    cursor: pointer;
	    text-decoration: none;
	    color: inherit;
	}
	
	.saleTradeList-card:hover {
	    transform: translateY(-5px);
	    box-shadow: 0 4px 12px rgba(0,0,0,0.1);
	}
	
	.saleTradeList-img {
	    width: 100%;
	    height: 200px;
	    background: #f0f0f0;
	    overflow: hidden;
	}
	
	.saleTradeList-img img {
	    width: 100%;
	    height: 100%;
	    object-fit: cover;
	}
	
	.saleTradeList-content {
	    padding: 15px;
	}
	
	.saleTradeList-title {
	    font-size: 15px;
	    font-weight: 600;
	    color: #333;
	    margin-bottom: 8px;
	    overflow: hidden;
	    text-overflow: ellipsis;
	    white-space: nowrap;
	}
	
	.saleTradeList-price {
	    font-size: 18px;
	    font-weight: 700;
	    color: #FF6F61;
	    margin-bottom: 10px;
	}
	
	.saleTradeList-info {
	    display: flex;
	    align-items: center;
	    gap: 12px;
	    margin-bottom: 10px;
	    font-size: 13px;
	    color: #666;
	}
	
	.saleTradeList-location,
	.saleTradeList-likes {
	    display: flex;
	    align-items: center;
	    gap: 4px;
	}
	
	.saleTradeList-location svg,
	.saleTradeList-likes svg {
	    width: 14px;
	    height: 14px;
	}
	
	.saleTradeList-meta {
	    display: flex;
	    justify-content: space-between;
	    align-items: center;
	    font-size: 12px;
	    color: #999;
	    padding-top: 10px;
	    border-top: 1px solid #f0f0f0;
	}
	
	.saleTradeList-seller {
	    font-weight: 500;
	}
	
	.saleTradeList-date {
	    color: #bbb;
	}
	
	/* 반응형 */
	@media (max-width: 768px) {
	    .saleTradeList-grid {
	        grid-template-columns: repeat(auto-fill, minmax(160px, 1fr));
	        gap: 15px;
	    }
	    
	    .saleTradeList-img {
	        height: 160px;
	    }
	    
	    .saleTradeList-search-wrapper {
	        width: 100%;
	    }
	    
	    .btn-register-product {
	        width: 100%;
	        justify-content: center;
	    }
	}
	
	/* detail.jsp */
	.main-detail {
	    margin-top: 70px;
	    padding: 40px 20px;
	}
	
	.detail-container {
	    max-width: 1200px;
	    margin: 0 auto;
	    display: grid;
	    grid-template-columns: 1fr 1fr;
	    gap: 60px;
	}
	
	/* 이미지 섹션 */
	.detail-image-section {
	    /* position: sticky; */
	    top: 100px;
	    height: fit-content;
	    margin-top: 25px;
	}
	
	.detail-main-image {
	    width: 100%;
	    aspect-ratio: 1;
	    border-radius: 16px;
	    overflow: hidden;
	    background: #f0f0f0;
	    margin-bottom: 20px;
	}
	
	.detail-main-image img {
	    width: 100%;
	    height: 100%;
	    object-fit: cover;
	}
	
	/* 정보 섹션 */
	.detail-info-section {
	    padding: 20px 0;
	}
	
	/* 판매자를 맨 아래로 이동 */
	.detail-seller {
	    display: flex;
	    align-items: center;
	    gap: 12px;
	    padding-top: 20px;
	    border-top: 1px solid #eee;
	    margin-top: 20px;
	    order: 10;
	}
	
	.detail-seller-img {
	    width: 50px;
	    height: 50px;
	    border-radius: 50%;
	    object-fit: cover;
	}
	
	.detail-seller-name {
	    font-size: 16px;
	    font-weight: 700;
	    color: #333;
	}
	
	.detail-seller-location {
	    font-size: 13px;
	    color: #999;
	}
	
	/* 제목을 맨 위로 */
	.detail-title {
	    font-size: 26px;
	    font-weight: 700;
	    color: #333;
	    margin-bottom: 12px;
	    line-height: 1.4;
	    order: 1;
	}
	
	.detail-meta {
	    display: flex;
	    gap: 12px;
	    font-size: 13px;
	    color: #999;
	    margin-bottom: 20px;
	    order: 2;
	}
	
	.detail-meta span::after {
	    content: "·";
	    margin-left: 12px;
	}
	
	.detail-meta span:last-child::after {
	    content: "";
	}
	
	.detail-pricezon {
	    font-size: 32px;
	    font-weight: 700;
	    margin-bottom: 20px;
	    order: 3;
	}
	
	.detail-pricezon > div {
	    display: flex;
	    align-items: baseline;
	    gap: 10px;
	}
	
	.detail-status-badge {
	    display: inline-block;
	    padding: 6px 14px;
	    border-radius: 20px;
	    font-size: 13px;
	    font-weight: 600;
	    margin-bottom: 20px;
	    order: 4;
	}
	
	.detail-status-badge.sold {
	    background: #e2e3e5;
	    color: #6c757d;
	}
	
	.detail-description {
	    padding: 30px 0;
	    border-top: 1px solid #eee;
	    order: 5;
	}
	
	.detail-description h3 {
	    font-size: 18px;
	    font-weight: 700;
	    color: #333;
	    margin-bottom: 15px;
	}
	
	.detail-description p {
	    font-size: 15px;
	    color: #666;
	    line-height: 1.7;
	    white-space: pre-wrap;
	}
	
	/* 지도 */
	.detail-map-section {
	    padding: 30px 0;
	    border-top: 1px solid #eee;
	    order: 6;
	}
	
	.detail-map-section h3 {
	    font-size: 18px;
	    font-weight: 700;
	    color: #333;
	    margin-bottom: 15px;
	}
	
	.detail-map {
	    width: 100%;
	    height: 250px;
	    border-radius: 12px;
	    margin-bottom: 10px;
	}
	
	.detail-address {
	    font-size: 14px;
	    color: #666;
	}
	
	/* 액션 버튼을 판매자 정보 위로 */
	.detail-actions {
	    display: flex;
	    gap: 12px;
	    margin-top: 30px;
	    order: 9;
	}
	
	.detail-btn-recommend {
	    padding: 14px 24px;
	    border: 2px solid #FF6F61;
	    border-radius: 8px;
	    background: white;
	    color: #FF6F61;
	    font-size: 15px;
	    font-weight: 600;
	    cursor: pointer;
	    transition: 0.2s;
	    display: flex;
	    align-items: center;
	    gap: 8px;
	}
	
	.detail-btn-recommend svg {
	    width: 20px;
	    height: 20px;
	}
	
	.detail-btn-recommend:hover {
	    background: #FF6F61;
	    color: white;
	}
	
	.detail-btn-buy {
	    flex: 1;
	    padding: 14px;
	    border: none;
	    border-radius: 8px;
	    background: linear-gradient(135deg, #FF6F61, #9B59B6);
	    color: white;
	    font-size: 16px;
	    font-weight: 700;
	    cursor: pointer;
	    transition: 0.2s;
	}
	
	.detail-btn-buy:hover {
	    transform: translateY(-2px);
	    box-shadow: 0 4px 12px rgba(255, 111, 97, 0.3);
	}
	
	.detail-btn-sold {
	    flex: 1;
	    padding: 14px;
	    border: none;
	    border-radius: 8px;
	    background: #e2e3e5;
	    color: #6c757d;
	    font-size: 16px;
	    font-weight: 700;
	    cursor: not-allowed;
	}
	
	/* info-section을 flexbox로 변경하여 순서 조정 */
	.detail-info-section {
	    display: flex;
	    flex-direction: column;
	    padding: 20px 0;
	}
	
	/* 다른 상품 */
	.detail-other-section {
	    max-width: 1200px;
	    margin: 60px auto 0;
	    padding-top: 40px;
	    border-top: 8px solid #f5f6fa;
	}
	
	.detail-other-section h2 {
	    font-size: 22px;
	    font-weight: 700;
	    color: #333;
	    margin-bottom: 20px;
	}
	
	.detail-other-grid {
	    display: grid;
	    grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
	    gap: 20px;
	}
	
	.detail-other-card {
	    text-decoration: none;
	    color: inherit;
	    transition: 0.2s;
	}
	
	.detail-other-card:hover {
	    transform: translateY(-4px);
	}
	
	.detail-other-img {
	    width: 100%;
	    aspect-ratio: 1;
	    border-radius: 12px;
	    overflow: hidden;
	    background: #f0f0f0;
	    margin-bottom: 10px;
	}
	
	.detail-other-img img {
	    width: 100%;
	    height: 100%;
	    object-fit: cover;
	}
	
	.detail-other-title {
	    font-size: 14px;
	    font-weight: 500;
	    color: #333;
	    margin-bottom: 6px;
	    overflow: hidden;
	    text-overflow: ellipsis;
	    white-space: nowrap;
	}
	
	.detail-other-price {
	    font-size: 16px;
	    font-weight: 700;
	    color: #FF6F61;
	}
	
	/* 모달 */
	.detail-modal-overlay {
	    display: none;
	    position: fixed;
	    top: 0;
	    left: 0;
	    width: 100%;
	    height: 100%;
	    background: rgba(0,0,0,0.6);
	    z-index: 1000;
	    align-items: center;
	    justify-content: center;
	}
	
	.detail-modal {
	    background: white;
	    border-radius: 16px;
	    padding: 30px;
	    width: 90%;
	    max-width: 500px;
	    max-height: 90vh;
	    overflow-y: auto;
	    position: relative;
	}
	
	.detail-modal-close {
	    position: absolute;
	    top: 20px;
	    right: 20px;
	    width: 32px;
	    height: 32px;
	    border: none;
	    background: #f0f0f0;
	    border-radius: 50%;
	    font-size: 24px;
	    cursor: pointer;
	    line-height: 1;
	}
	
	.detail-modal-title {
	    font-size: 22px;
	    font-weight: 700;
	    margin-bottom: 20px;
	}
	
	.detail-modal-product {
	    display: flex;
	    gap: 15px;
	    padding: 15px;
	    background: #f8f9fa;
	    border-radius: 12px;
	    margin-bottom: 25px;
	}
	
	.detail-modal-product img {
	    width: 80px;
	    height: 80px;
	    border-radius: 8px;
	    object-fit: cover;
	}
	
	.detail-modal-product-title {
	    font-size: 15px;
	    font-weight: 600;
	    margin-bottom: 6px;
	}
	
	.detail-modal-product-price {
	    font-size: 18px;
	    font-weight: 700;
	    color: #FF6F61;
	}
	
	.detail-modal-payment h3 {
	    font-size: 16px;
	    font-weight: 700;
	    margin-bottom: 15px;
	}
	
	.detail-modal-option,
	.detail-modal-radio {
	    display: flex;
	    align-items: center;
	    gap: 10px;
	    padding: 12px;
	    border: 1px solid #ddd;
	    border-radius: 8px;
	    margin-bottom: 10px;
	    cursor: pointer;
	}
	
	.detail-modal-option input,
	.detail-modal-radio input {
	    width: 18px;
	    height: 18px;
	    cursor: pointer;
	}
	
	.detail-modal-mileage {
	    display: none;
	    margin: 15px 0;
	    padding: 15px;
	    background: #f8f9fa;
	    border-radius: 8px;
	}
	
	.detail-modal-input {
	    width: 100%;
	    padding: 12px;
	    border: 1px solid #ddd;
	    border-radius: 8px;
	    margin: 10px 0;
	}
	
	.detail-modal-final {
	    margin-top: 10px;
	    font-size: 15px;
	}
	
	.detail-modal-wallet {
	    padding: 15px;
	    background: #f8f9fa;
	    border-radius: 8px;
	    margin: 20px 0;
	}
	
	.detail-modal-wallet div {
	    font-size: 14px;
	    margin-bottom: 8px;
	}
	
	.detail-modal-btn {
	    width: 100%;
	    padding: 16px;
	    border: none;
	    border-radius: 8px;
	    background: linear-gradient(135deg, #FF6F61, #9B59B6);
	    color: white;
	    font-size: 16px;
	    font-weight: 700;
	    cursor: pointer;
	}
	
	.detail-modal-btn:disabled {
	    background: #ddd;
	    cursor: not-allowed;
	}
	
	/* 반응형 */
	@media (max-width: 1024px) {
	    .detail-container {
	        grid-template-columns: 1fr;
	        gap: 30px;
	    }
	    
	    .detail-image-section {
	        position: static;
	    }
	}
	/* write.jsp */
	.main-write {
	    margin-top: 70px;
	    min-height: calc(100vh - 140px);
	    display: flex;
	    justify-content: center;
	    padding: 40px 20px;
	}
	
	.write-container {
	    width: 100%;
	    max-width: 700px;
	    background: white;
	    border-radius: 16px;
	    padding: 50px 40px;
	    box-shadow: 0 2px 12px rgba(0,0,0,0.1);
	    margin-bottom: 40px;
	}
	
	.write-title {
	    text-align: center;
	    font-size: 28px;
	    font-weight: 700;
	    margin-bottom: 12px;
	    color: #333;
	}
	
	.write-subtitle {
	    text-align: center;
	    font-size: 15px;
	    color: #888;
	    margin-bottom: 40px;
	}
	
	/* Textarea + GPT 버튼 영역 */
    .btn-gpt {
        margin-bottom: 10px;
        padding: 10px 20px;
        background: white;
        color: #ff6987;
        border: 2px solid #ff6987;
        border-radius: 8px;
        font-size: 14px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s;
        display: inline-flex;
        align-items: center;
        gap: 6px;
    }

    .btn-gpt:hover {
        background: #ff6987;
        color: white;
        transform: translateY(-1px);
        box-shadow: 0 4px 12px rgba(255, 105, 135, 0.3);
    }
    
    .gpt-preview-buttons {
        display: flex;
        gap: 10px;
    }
    
    .btn-apply-gpt {
        background: white;
        color: #ff6987;
        border: 2px solid #ff6987;
        border-radius: 8px;
        font-size: 14px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s;
        flex: 1;
    }

    .btn-apply-gpt:hover {
        background: #ff6987;
        color: white;
        transform: translateY(-1px);
        box-shadow: 0 4px 12px rgba(255, 105, 135, 0.3);
    }

    .btn-retry-gpt {
        background: white;
        color: #9B59B6;
        border: 2px solid #9B59B6;
        border-radius: 8px;
        font-size: 14px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s;
        flex: 1;
    }

    .btn-retry-gpt:hover {
        background: #9B59B6;
        color: white;
        transform: translateY(-1px);
        box-shadow: 0 4px 12px rgba(155, 89, 182, 0.3);
    }
	
	/* 이미지 업로드 */
	.write-field {
	    margin-bottom: 25px;
	}
	
	.write-label {
	    display: block;
	    font-size: 14px;
	    font-weight: 600;
	    color: #333;
	    margin-bottom: 8px;
	}
	
	.write-image-upload {
	    margin-bottom: 30px;
	}
	
	.write-image-label {
	    display: block;
	    cursor: pointer;
	}
	
	.write-image-preview {
	    width: 100%;
	    height: 300px;
	    border: 2px dashed #ddd;
	    border-radius: 12px;
	    display: flex;
	    flex-direction: column;
	    align-items: center;
	    justify-content: center;
	    background: #f8f9fa;
	    transition: 0.2s;
	    overflow: hidden;
	}
	
	.write-image-preview:hover {
	    border-color: #FF6F61;
	    background: #fff5f4;
	}
	
	.write-image-preview svg {
	    width: 60px;
	    height: 60px;
	    margin-bottom: 10px;
	}
	
	.write-image-preview p {
	    font-size: 14px;
	    color: #999;
	}
	
	.write-image-preview img {
	    width: 100%;
	    height: 100%;
	    object-fit: cover;
	}
	
	/* 입력 필드 */
	.write-input {
	    width: 100%;
	    padding: 12px 15px;
	    border: 1px solid #ddd;
	    border-radius: 8px;
	    font-size: 14px;
	    box-sizing: border-box;
	    transition: 0.2s;
	}
	
	.write-input:focus {
	    outline: none;
	    border-color: #FF6F61;
	}
	
	.write-textarea {
	    width: 100%;
	    padding: 12px 15px;
	    border: 1px solid #ddd;
	    border-radius: 8px;
	    font-size: 14px;
	    box-sizing: border-box;
	    transition: 0.2s;
	    resize: vertical;
	    font-family: inherit;
	}
	
	.write-textarea:focus {
	    outline: none;
	    border-color: #FF6F61;
	}
	
	.write-select {
	    width: 100%;
	    padding: 12px 15px;
	    border: 1px solid #ddd;
	    border-radius: 8px;
	    font-size: 14px;
	    box-sizing: border-box;
	    transition: 0.2s;
	}
	
	.write-select:focus {
	    outline: none;
	    border-color: #FF6F61;
	}
	/* 가로 배치 */
	.write-field-row {
	    display: grid;
	    grid-template-columns: 2fr 1fr;
	    gap: 15px;
	    margin-bottom: 25px;
	}
	
	/* 단위 표시 */
	.write-input-with-unit {
	    position: relative;
	}
	
	.write-input-with-unit input {
	    padding-right: 40px;
	}
	
	.write-input-unit {
	    position: absolute;
	    right: 15px;
	    top: 50%;
	    transform: translateY(-50%);
	    font-size: 14px;
	    font-weight: 600;
	    color: #FF6F61;
	}
	
	.write-input-unitM {
	    position: absolute;
	    right: 15px;
	    top: 50%;
	    transform: translateY(-50%);
	    font-size: 14px;
	    font-weight: 600;
	    color: #9B59B6;
	}
	
	/* 체크박스 */
	.write-checkbox {
	    display: flex;
	    align-items: center;
	    gap: 8px;
	    margin-top: 10px;
	    cursor: pointer;
	}
	
	.write-checkbox input[type="checkbox"] {
	    width: 18px;
	    height: 18px;
	    cursor: pointer;
	}
	
	.write-checkbox span {
	    font-size: 14px;
	    color: #666;
	}
	
	/* 주소 검색 */
	.write-input-row {
	    display: flex;
	    gap: 10px;
	}
	
	.write-input-row input {
	    flex: 1;
	}
	
	.write-btn-search {
	    padding: 12px 20px;
	    background: white;
	    border: 1px solid #ddd;
	    border-radius: 8px;
	    cursor: pointer;
	    font-size: 14px;
	    font-weight: 600;
	    white-space: nowrap;
	    transition: 0.2s;
	}
	
	.write-btn-search:hover {
	    background: #f8f8f8;
	    border-color: #FF6F61;
	    color: #FF6F61;
	}
	
	/* 제출 버튼 */
	.write-submit-btn {
	    width: 100%;
	    padding: 16px;
	    background: linear-gradient(135deg, #FF6F61, #9B59B6);
	    border: none;
	    border-radius: 10px;
	    color: white;
	    font-size: 16px;
	    font-weight: 700;
	    cursor: pointer;
	    transition: 0.2s;
	    margin-top: 30px;
	}
	
	.write-submit-btn:hover {
	    transform: translateY(-2px);
	    box-shadow: 0 4px 12px rgba(255, 111, 97, 0.3);
	}
	
	/* 반응형 */
	@media (max-width: 768px) {
	    .write-field-row {
	        grid-template-columns: 1fr;
	    }
	    
	    .write-image-preview {
	        height: 200px;
	    }
	}
	
	/* 수정/삭제 버튼 */
	.detail-btn-edit {
	    flex: 1;
	    padding: 14px;
	    border: 1px solid #FF6F61;
	    border-radius: 8px;
	    background: white;
	    color: #FF6F61;
	    font-size: 16px;
	    font-weight: 700;
	    cursor: pointer;
	    transition: 0.2s;
	}
	
	.detail-btn-edit:hover {
	    background: #FF6F61;
	    color: white;
	    transform: translateY(-2px);
	}
	
	.detail-btn-delete {
	    flex: 1;
	    padding: 14px;
	    border: 1px solid #dc3545;
	    border-radius: 8px;
	    background: white;
	    color: #dc3545;
	    font-size: 16px;
	    font-weight: 700;
	    cursor: pointer;
	    transition: 0.2s;
	}
	
	.detail-btn-delete:hover {
	    background: #dc3545;
	    color: white;
	    transform: translateY(-2px);
	}
	
	.detail-btn-login {
	    flex: 1;
	    padding: 14px;
	    border: 1px solid #ddd;
	    border-radius: 8px;
	    background: white;
	    color: #666;
	    font-size: 16px;
	    font-weight: 700;
	    cursor: pointer;
	    transition: 0.2s;
	}
	
	.detail-btn-login:hover {
	    background: #f8f9fa;
	    border-color: #FF6F61;
	    color: #FF6F61;
	}
	
	/* traList.jsp */
	.main-tralist {
	    margin-top: 70px;
	    min-height: calc(100vh - 140px);
	    padding: 40px 20px;
	    background: #f8f9fa;
	}
	
	.tralist-container {
	    max-width: 1200px;
	    margin: 0 auto;
	}
	
	.tralist-header {
	    margin-bottom: 30px;
	}
	
	.tralist-title {
	    font-size: 28px;
	    font-weight: 700;
	    color: #333;
	    margin-bottom: 8px;
	}
	
	.tralist-subtitle {
	    font-size: 15px;
	    color: #888;
	}
	
	.tralist-table-wrapper {
	    background: white;
	    border-radius: 16px;
	    overflow: hidden;
	    box-shadow: 0 2px 12px rgba(0,0,0,0.08);
	}
	
	.tralist-table {
	    width: 100%;
	    border-collapse: collapse;
	}
	
	.tralist-table thead {
	    background: linear-gradient(135deg, #FF6F61, #9B59B6);
	}
	
	.tralist-table thead th {
	    padding: 16px 20px;
	    text-align: left;
	    font-size: 14px;
	    font-weight: 600;
	    color: white;
	    border: none;
	}
	
	.tralist-table tbody tr {
	    border-bottom: 1px solid #f0f0f0;
	    transition: background 0.2s;
	}
	
	.tralist-table tbody tr:hover {
	    background: #f8f9fa;
	}
	
	.tralist-table tbody tr:last-child {
	    border-bottom: none;
	}
	
	.tralist-table tbody td {
	    padding: 18px 20px;
	    font-size: 14px;
	    color: #333;
	    vertical-align: middle;
	}
	
	.tralist-date {
	    color: #666;
	    font-size: 13px;
	}
	
	.tralist-title-link {
	    color: #333;
	    text-decoration: none;
	    font-weight: 500;
	    transition: color 0.2s;
	}
	
	.tralist-title-link:hover {
	    color: #FF6F61;
	}
	
	.tralist-recommend {
	    display: inline-flex;
	    align-items: center;
	    gap: 4px;
	    padding: 6px 12px;
	    background: #fff5f4;
	    color: #FF6F61;
	    border-radius: 20px;
	    font-weight: 600;
	    font-size: 13px;
	}
	
	.tralist-status {
	    display: inline-block;
	    padding: 6px 16px;
	    border-radius: 20px;
	    font-size: 13px;
	    font-weight: 600;
	}
	
	.status-selling {
	    background: #e3f2fd;
	    color: #1976d2;
	}
	
	.status-completed {
	    background: #f1f8e9;
	    color: #689f38;
	}
	
	.tralist-actions {
	    display: flex;
	    gap: 8px;
	}
	
	.btn-reupload {
	    padding: 8px 16px;
	    background: white;
	    color: #FF6F61;
	    border: 2px solid #FF6F61;
	    border-radius: 8px;
	    font-size: 13px;
	    font-weight: 600;
	    cursor: pointer;
	    text-decoration: none;
	    transition: all 0.2s;
	    display: inline-block;
	}
	
	.btn-reupload:hover {
	    background: #FF6F61;
	    color: white;
	    transform: translateY(-1px);
	}
	
	.btn-delete {
	    padding: 8px 16px;
	    background: white;
	    color: #9B59B6;
	    border: 2px solid #9B59B6;
	    border-radius: 8px;
	    font-size: 13px;
	    font-weight: 600;
	    cursor: pointer;
	    transition: all 0.2s;
	}
	
	.btn-delete:hover {
	    background: #9B59B6;
	    color: white;
	    transform: translateY(-1px);
	}
	
	.tralist-empty {
	    text-align: center;
	    padding: 60px 20px;
	    color: #999;
	}
	
	.tralist-empty svg {
	    width: 80px;
	    height: 80px;
	    margin-bottom: 20px;
	    opacity: 0.3;
	}
	
	.tralist-empty p {
	    font-size: 16px;
	    margin-bottom: 20px;
	}
	
	.btn-go-write {
	    display: inline-block;
	    padding: 12px 24px;
	    background: linear-gradient(135deg, #FF6F61, #9B59B6);
	    color: white;
	    text-decoration: none;
	    border-radius: 8px;
	    font-weight: 600;
	    transition: all 0.2s;
	}
	
	.btn-go-write:hover {
	    transform: translateY(-2px);
	    box-shadow: 0 4px 12px rgba(255, 111, 97, 0.3);
	}
	
	@media (max-width: 768px) {
	    .tralist-table thead th,
	    .tralist-table tbody td {
	        padding: 12px 10px;
	        font-size: 13px;
	    }
	    
	    .tralist-actions {
	        flex-direction: column;
	        gap: 6px;
	    }
	    
	    .btn-reupload,
	    .btn-delete {
	        width: 100%;
	        text-align: center;
	    }
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
	
	<c:if test="${not empty sessionScope.notifyMsg}">
	    <script>
	        alert("${sessionScope.notifyMsg}");
	    </script>
	    <c:remove var="notifyMsg" scope="session"/>
	</c:if>
	
	<div class="header-col left">
	    <div class="logo">
	    	<a href="/main/home">살래팔래</a>
	    </div>
    </div>
    
    <div class="header-col center">
	    <div class="menu-group">
	        <a href="/traBoard/saleTradeList"><button>중고 물품</button></a>
	        <button>리뷰 피드</button>
	        <button>나눔</button>
	    </div>
    </div>
    
	<div class="header-col right">
		<!-- 로그인 X -->
		<sec:authorize access="isAnonymous()">  
		    <div class="auth-group">
		        <a href="/member/login"><button class="auth-login">로그인</button></a>
		        <a href="/member/joinChoice"><button class="auth-join">회원가입</button></a>
		    </div>
		</sec:authorize>
		
		<!-- 로그인 O -->
		<sec:authorize access="isAuthenticated()">
		    <div class="user-dropdown" id="userDropdown">
		        <div class="user-info-group">
		            <a href="/member/profileEdit">
		                <img src="/upload/${loginInfo.profile_img}" 
		                     class="user-profile-img">
		            </a> 
		                
		            <span class="user-nickname">
		                <a href="#">${loginInfo.nickname}</a>
		            </span>
		            
		            <span class="dropdown-arrow">▼</span>
		        </div>
		        
		        <!-- 드롭다운 메뉴 -->
		        <div class="dropdown-menu">
		            <div class="dropdown-header">
		                <div class="user-name">${loginInfo.nickname}</div>
		                <div class="user-email">${loginInfo.email}</div>
		            </div>

		            <div class="dropdown-stats">
		                <div class="stat-item">
		                    <div class="stat-label"><a href="/fintech/chargePoint">살래P</a></div>
		                    <div class="stat-value"><a href="/fintech/chargePoint"><fmt:formatNumber value="${loginInfo.wallet_balance }" /></a></div>
		                </div>
		                <div class="stat-item">
		                    <div class="stat-label">팔래M</div>
		                    <div class="stat-value"><fmt:formatNumber value="${loginInfo.wallet_mileage}" /></div>
		                </div>
		            </div>

		            <a href="/member/read" class="dropdown-item">
		                <span class="dropdown-item-icon">👤</span>
		                <span>MY홈</span>
		            </a>
		            <a href="/member/traList" class="dropdown-item">
		                <span class="dropdown-item-icon">📋</span>
		                <span>등록 물품</span>
		            </a>
		            <a href="#" class="dropdown-item">
		                <span class="dropdown-item-icon">🕒</span>
		                <span>최근본 글</span>
		            </a>
		            <a href="/member/paymentHistory" class="dropdown-item">
		                <span class="dropdown-item-icon">💰</span>
		                <span>결제내역</span>
		            </a>
		            
		            <a href="/chat/list" class="dropdown-item" style="display: flex; align-items: center;">
					    <span class="dropdown-item-icon">💬</span>
					    <span>채팅</span>
					    <span id="globalChatBadge" style="display:none; background:#FF6F61; color:white; border-radius:50%; padding:2px 6px; font-size:11px; margin-left:5px; font-weight:bold;">N</span>
					</a>

		            <!-- 판매 권한 UI -->
		            <c:choose>
		                <c:when test="${loginInfo.seller_status == 'N'}">
		                    <form id="sellerRequestForm" action="/seller/request" method="post" style="display:none;">
		                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
		                    </form>
		                    <button id="btnSellerRequest" class="dropdown-item" style="width:100%; text-align:left; background:none; border:none; cursor:pointer; padding:12px 20px;">
		                        <span class="dropdown-item-icon">🏪</span>
		                        <span>판매 권한 신청</span>
		                    </button>
		                </c:when>
		                <c:when test="${loginInfo.seller_status == 'W'}">
		                    <div class="dropdown-item" style="color:#888;">
		                        <span class="dropdown-item-icon">⏳</span>
		                        <span>판매 권한 심사중...</span>
		                    </div>
		                </c:when>
		                <c:when test="${loginInfo.seller_status == 'Y'}">
		                    <div class="dropdown-item" style="color:#9B59B6; font-weight:600;">
		                        <span class="dropdown-item-icon">✅</span>
		                        <span>판매회원</span>
		                    </div>
		                </c:when>
		            </c:choose>

				    
		            <div class="dropdown-logout">
		                <form action="/member/logout" method="post" style="margin:0;">
		                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
		                    <button class="logout-btn-dropdown" type="submit">
		                        <div class="dropdown-item">
		                            <span class="dropdown-item-icon">🚪</span>
		                            <span>로그아웃</span>
		                        </div>
		                    </button>
		                </form>
		            </div>
		            <a href="#" id="notificationItem" >
			            <!-- <img src="/resources/img/free-icon-mails-5028538.png" class="bell-icon"> -->
			            <c:if test="${loginInfo.notify_flag == 'Y'}">
			                <span class="notify-badge"></span>
			            </c:if>
			           <!--  <span>SMS 알림</span> -->
			        </a>
		        </div>
		    </div>
		</sec:authorize>
	</div>
	
	<!-- 관리자만 -->
	<sec:authorize access="hasRole('ROLE_ADMIN')">
	    <a href="/admin">관리자 페이지</a>
	</sec:authorize>
<script type="text/javascript">
	// jQuery - 포인트 충전
	function chargePoint() {
	    alert('살래포인트 충전 페이지로 이동합니다.');
	    // location.href = '/charge/point';
	}
	
	$(document).ready(function() {
        // ==========================================
        // 1. 드롭다운 및 UI 이벤트 로직
        // ==========================================
        
	    // 드롭다운 토글
	    $('.user-info-group').on('click', function(e) {
	        e.stopPropagation();
	        $('#userDropdown').toggleClass('active');
	    });

	    // 드롭다운 외부 클릭 시 닫기
	    $(document).on('click', function(e) {
	        if (!$(e.target).closest('#userDropdown').length) {
	            $('#userDropdown').removeClass('active');
	        }
	    });

	    // ESC 키로 드롭다운 닫기
	    $(document).on('keydown', function(e) {
	        if (e.key === 'Escape') {
	            $('#userDropdown').removeClass('active');
	        }
	    });
	    
	    // 드롭다운 메뉴 내부 클릭 시 이벤트 전파 막기 (닫히지 않게)
	    $('.dropdown-menu').on('click', function(e) {
	    	if (!$(e.target).closest('a, button, form').length) {
	            e.stopPropagation();
	        }
	    });
	    
		// 판매 권한 신청
		$(document).on("click", "#btnSellerRequest", function(e) {
			e.preventDefault();
	        e.stopPropagation();
	        
		    swal({
		        title: "판매 권한 신청",
		        text: "신청 후 처리까지 다소 시간이 소요될 수 있습니다.",
		        icon: "warning",
		        buttons: ["취소", "신청하기"],
		    }).then((willApply) => {
		        if (willApply) {
		            $("#sellerRequestForm").submit();
		        }
		    });
		});
		
	    // 기존 알림 클릭 시 처리
	    $(document).on("click", "#notificationItem", function(e) {
	        e.preventDefault();
	        e.stopPropagation();
	        
	        // 빨간점이 있는 경우에만 알림 메시지 표시
	        if ($('.notify-badge').length > 0) {
	            swal({
	                title: "알림",
	                text: "판매 권한 신청 메일이 발송되었습니다.\n등록된 메일을 확인해 주세요.",
	                icon: "info",
	                button: "확인",
	            }).then(() => {
	                // 알림 확인 후 빨간점 제거 (AJAX로 서버에 알림 읽음 처리)
	                $.ajax({
	                    url: '/member/readNotification',
	                    type: 'POST',
	                    data: {
	                        "${_csrf.parameterName}": "${_csrf.token}"
	                    },
	                    success: function(response) {
	                        $('.notify-badge').fadeOut(300, function() {
	                            $(this).remove();
	                        });
	                    },
	                    error: function() {
	                        $('.notify-badge').fadeOut(300, function() {
	                            $(this).remove();
	                        });
	                    }
	                });
	            });
	        } else {
	            // 빨간점이 없으면 일반 알림 페이지로 이동
	            swal({
	                title: "알림",
	                text: "확인할 새로운 알림이 없습니다.",
	                icon: "info",
	                button: "확인",
	            });
	        }
	    });

        // ==========================================
        // 2. 실시간 채팅 알림(STOMP WebSocket) 로직
        // ==========================================
	    const headerMyId = "${loginInfo.member_id}"; 
	    
	    // 로그인 한 상태에서만 알림 웹소켓 연결
	    if(headerMyId && headerMyId !== "") {
	        const socket = new SockJS('/ws-stomp');
	        const headerStompClient = Stomp.over(socket);
            
            // 콘솔에 ping/pong 로그가 너무 많이 찍히면 아래 주석을 해제하세요.
            // headerStompClient.debug = null;

	        headerStompClient.connect({}, function (frame) {
	            console.log("글로벌 알림 웹소켓 연결 성공!");
	            
	            headerStompClient.subscribe('/sub/notify/' + headerMyId, function (message) {
	                const notifyMsg = JSON.parse(message.body);
	                
	                // 현재 내가 보고 있는 화면이 채팅방 화면(/chat/room)이 아닐 때만 알림 띄우기
	                if(window.location.pathname !== "/chat/room") {
	                    
	                    // 1. 헤더 메뉴에 빨간 뱃지 띄우기
	                    $("#globalChatBadge").show().text("New");
	                    
	                    // 2. SweetAlert 띄우기
	                    swal({
	                        title: notifyMsg.sender_nickname + "님의 새 메시지",
	                        text: notifyMsg.message_text,
	                        icon: "info",
	                        buttons: {
	                            cancel: "닫기",
	                            catch: {
	                                text: "채팅방으로 이동",
	                                value: "go",
	                            }
	                        },
	                    }).then((value) => {
	                        if (value === "go") {
	                            location.href = "/chat/room?room_id=" + notifyMsg.room_id;
	                        }
	                    });
	                }
	            });
	        });
	    }
	});
</script>
</header>