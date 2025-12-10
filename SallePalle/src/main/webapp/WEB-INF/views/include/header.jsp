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
	
	/* 로그인 후 유저 정보 */
    .user-info-group {
        display: flex;
        align-items: center;
        gap: 20px;
        padding: 8px 15px;
        background: #eee;
        border-radius: 25px;
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
    
    /* 3등분 레이아웃 */
	.header-col {
	    flex: 1;
	    display: flex;
	    align-items: center;
	}
	
	.header-col.center {
	    justify-content: center;
	}
	
	.header-col.right {
	    justify-content: flex-end;
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
    .main-home {
        margin-top: 100px;
        width: 100%;
        display: flex;
        justify-content: center;
    }

    .main-inner {
        width: 900px;
    }

    /* 검색창 */
    .search-box {
        display: flex;
        justify-content: center;
        margin-bottom: 25px;
    }

    .search-box input {
        width: 80%;
        padding: 12px 20px;
        border-radius: 30px;
        border: 1px solid #ccc;
        font-size: 15px;
    }

    /* 카테고리 탭 */
    .category {
        display: flex;
        gap: 12px;
        overflow-x: auto;
        padding-bottom: 5px;
        margin-bottom: 25px;
    }

    .category button {
        padding: 10px 20px;
        border-radius: 20px;
        border: 1px solid #ddd;
        background: white;
        cursor: pointer;
        font-size: 14px;
        white-space: nowrap;
    }

    .category button:hover {
        border-color: #FF6F61;
        color: #FF6F61;
    }

    /* 게시물 피드 (2~3열 반응형) */
    .post-list {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
        gap: 20px;
    }

    .post-card {
        background: white;
        border-radius: 12px;
        border: 1px solid #eee;
        overflow: hidden;
        transition: 0.2s;
        cursor: pointer;
    }

    .post-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 4px 12px rgba(0,0,0,0.08);
    }

    .post-img {
        width: 100%;
        height: 200px;
        background: #dcdcdc;
    }

    .post-content {
        padding: 12px 15px;
    }

    .post-title {
        font-size: 15px;
        font-weight: 600;
        margin-bottom: 5px;
    }

    .post-price {
        color: #FF6F61;
        font-weight: 700;
        margin-top: 4px;
    }
    
	
	/* profileEdit.jsp */

	
	/* read.jsp */

	
	/* update.jsp */

    
    /* joinChoice.jsp */
    .main-joinChoice {
        margin-top: 70px;
        min-height: calc(100vh - 140px);
        display: flex;
        align-items: center;
        justify-content: center;
        padding: 40px 20px;
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
    /* footer.jsp */
    footer {
        padding: 30px 0;
        text-align: center;
        color: #888;
        font-size: 13px;
        background: white;
        border-top: 1px solid #eee;
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
	<div class="header-col left">
	    <div class="logo">
	    	<a href="/main/home">살래팔래</a>
	    </div>
    </div>
    
    <div class="header-col center">
	    <div class="menu-group">
	        <button>중고 물품</button>
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
		    <div class="user-info-group">
		    	<a href="/member/read">
			    	<img src="/upload/${loginInfo.profile_img}" 
			    	     class="user-profile-img">
		    	</a> 
		    	    
		    	<span class="user-nickname">
		    		<a href="/member/read">${loginInfo.nickname}</a>
		    	</span>
		    	
		    	<div class="user-points">
		            <span>살래P</span>
		            <strong>
		            	25,000<fmt:formatNumber value="" pattern="#,###"/>
		            </strong>
		            <button class="btn-charge" onclick="chargePoint()" title="포인트 충전">+</button>
		        </div>
		        
		        <div class="user-mileage">
		            <span>팔래M</span>
		            <strong>
		            	2,500<fmt:formatNumber value="" pattern="#,###"/>
		            </strong>
		        </div>
		        
		        <!-- 판매 권한 UI 추가 -->
		        <c:choose>
		            <%-- 일반 회원(N)만 버튼 보임 --%>
		            <c:when test="${loginInfo.seller_status == 'N'}">
		                <button id="btnSellerRequest" 
		                        style="padding: 7px 14px; border-radius: 8px; border:1px solid #FF6F61; 
		                               background:white; color:#FF6F61; cursor:pointer;">
		                    판매 권한 신청
		                </button>
		            </c:when>
		
		            <%-- 승인 대기(W) --%>
		            <c:when test="${loginInfo.seller_status == 'W'}">
		                <span style="font-size:13px; color:#888;">판매 권한 심사중...</span>
		            </c:when>
		
		            <%-- 승인 완료(Y) --%>
		            <c:when test="${loginInfo.seller_status == 'Y'}">
		                <span style="font-size:13px; color:#9B59B6; font-weight:600;">판매회원</span>
		            </c:when>
		        </c:choose>
		        
		        <form action="/member/logout" method="post" >
			        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
			        <button class="btn-logout" type="submit" >
			            로그아웃
			        </button>
			    </form>
		    </div>  
		</sec:authorize>
	</div>
	<!-- 관리자만 -->
	<sec:authorize access="hasRole('ROLE_ADMIN')">
	    <a href="/admin">관리자 페이지</a>
	</sec:authorize>
<script type="text/javascript">
//포인트 충전
	function chargePoint() {
	    alert('살래포인트 충전 페이지로 이동합니다.');
		    // location.href = '/charge/point';
	}
	
	$(document).on("click", "#btnSellerRequest", function() {
	    swal({
	        title: "판매 권한 신청",
	        text: "신청 후 처리까지 다소 시간이 소요될 수 있습니다.",
	        icon: "warning",
	        buttons: ["취소", "신청하기"],
	    }).then((willApply) => {
	        if (willApply) {
	        	$.ajax({
	                url: "/seller/request",
	                type: "POST",        // ★ POST 요청
	                data: {},            // 전송 데이터 없으면 비워도 OK
	                success: function(result) {
	                    // 처리 성공 후 이동
	                    location.href = "/main/home";
	                },
	                error: function(xhr, status, error) {
	                    console.log("판매 권한 신청 실패:", error);
	                    alert("판매 권한 신청 처리 중 오류가 발생했습니다.");
	                }
	            });
	        }
	    });
	});
</script>
</header>