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
<title>관리자 대시보드 - 살래팔래</title>

<style>
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }

    body {
        font-family: 'Noto Sans KR', sans-serif;
        background: #f5f6fa;
    }

    /* 사이드바 */
    .admin-sidebar {
        position: fixed;
        left: 0;
        top: 0;
        width: 260px;
        height: 100vh;
        background: linear-gradient(180deg, #FF6F61 0%, #9B59B6 100%);
        padding: 30px 0;
        box-shadow: 2px 0 10px rgba(0,0,0,0.1);
        z-index: 100;
    }

    .admin-sidebar-logo {
        text-align: center;
        padding: 0 20px 30px;
        border-bottom: 1px solid rgba(255,255,255,0.2);
    }

    .admin-sidebar-logo h1 {
        font-size: 28px;
        font-weight: 800;
        color: white;
        margin-bottom: 5px;
    }

    .admin-sidebar-logo p {
        font-size: 13px;
        color: rgba(255,255,255,0.8);
        font-weight: 500;
    }

    .admin-sidebar-menu {
        padding: 30px 0;
    }

    .admin-menu-item {
        display: flex;
        align-items: center;
        gap: 15px;
        padding: 15px 25px;
        color: white;
        text-decoration: none;
        font-size: 15px;
        font-weight: 500;
        transition: 0.2s;
    }

    .admin-menu-item:hover {
        background: rgba(255,255,255,0.15);
        padding-left: 30px;
    }

    .admin-menu-item svg {
        width: 20px;
        height: 20px;
    }

    /* 메인 컨텐츠 */
    .main-home {
        margin-left: 260px;
        padding: 30px 40px;
    }

    .home-container {
        max-width: 1400px;
    }

    /* 헤더 */
    .home-header {
        background: white;
        padding: 25px 30px;
        border-radius: 15px;
        margin-bottom: 30px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .home-header-left h1 {
        font-size: 26px;
        font-weight: 700;
        color: #333;
        margin-bottom: 8px;
    }

    .home-header-left p {
        font-size: 14px;
        color: #888;
    }

    .home-header-right {
        display: flex;
        align-items: center;
        gap: 10px;
        padding: 12px 20px;
        background: linear-gradient(135deg, #FF6F61, #9B59B6);
        border-radius: 25px;
    }

    .home-admin-badge {
        width: 35px;
        height: 35px;
        border-radius: 50%;
        background: white;
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .home-admin-badge svg {
        width: 20px;
        height: 20px;
        fill: #FF6F61;
    }

    .home-admin-name {
        color: white;
        font-size: 14px;
        font-weight: 600;
    }

    /* 통계 카드 */
    .home-stats {
        display: grid;
        grid-template-columns: repeat(4, 1fr);
        gap: 20px;
        margin-bottom: 30px;
    }

    .home-stat-card {
        background: white;
        padding: 25px;
        border-radius: 15px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        display: flex;
        align-items: center;
        gap: 20px;
        transition: 0.2s;
    }

    .home-stat-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 4px 20px rgba(0,0,0,0.1);
    }

    .home-stat-icon {
        width: 60px;
        height: 60px;
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
        flex-shrink: 0;
    }

    .home-stat-icon.orange {
        background: linear-gradient(135deg, #FF6F61, #ff8a7d);
    }

    .home-stat-icon.purple {
        background: linear-gradient(135deg, #9B59B6, #b376d1);
    }

    .home-stat-icon.green {
        background: linear-gradient(135deg, #2ecc71, #27ae60);
    }

    .home-stat-icon.blue {
        background: linear-gradient(135deg, #3498db, #2980b9);
    }

    .home-stat-icon svg {
        width: 30px;
        height: 30px;
        fill: white;
    }

    .home-stat-info h3 {
        font-size: 13px;
        color: #888;
        margin-bottom: 5px;
        font-weight: 500;
    }

    .home-stat-info p {
        font-size: 26px;
        font-weight: 700;
        color: #333;
    }

    /* 메뉴 그리드 */
    .home-menu-grid {
        display: grid;
        grid-template-columns: repeat(4, 1fr);
        gap: 25px;
    }

    .home-menu-card {
        background: white;
        padding: 40px 30px;
        border-radius: 15px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        text-align: center;
        text-decoration: none;
        transition: 0.3s;
        border: 2px solid transparent;
    }

    .home-menu-card:hover {
        transform: translateY(-8px);
        box-shadow: 0 8px 25px rgba(255, 111, 97, 0.2);
        border-color: #FF6F61;
    }

    .home-menu-icon {
        width: 80px;
        height: 80px;
        border-radius: 50%;
        margin: 0 auto 20px;
        display: flex;
        align-items: center;
        justify-content: center;
        background: linear-gradient(135deg, #FF6F61, #9B59B6);
    }

    .home-menu-icon svg {
        width: 40px;
        height: 40px;
        fill: white;
    }

    .home-menu-card h3 {
        font-size: 20px;
        font-weight: 700;
        color: #333;
        margin-bottom: 10px;
    }

    .home-menu-card p {
        font-size: 14px;
        color: #888;
        line-height: 1.6;
    }

    /* 반응형 */
    @media (max-width: 1200px) {
        .home-menu-grid {
            grid-template-columns: repeat(2, 1fr);
        }
        
        .home-stats {
            grid-template-columns: repeat(2, 1fr);
        }
    }

    @media (max-width: 768px) {
        .admin-sidebar {
            width: 70px;
        }
        
        .main-home {
            margin-left: 70px;
        }
        
        .admin-sidebar-logo h1,
        .admin-sidebar-logo p,
        .admin-menu-item span {
            display: none;
        }
        
        .home-menu-grid {
            grid-template-columns: 1fr;
        }
        
        .home-stats {
            grid-template-columns: 1fr;
        }
    }
</style>

</head>
<body>

<!-- 사이드바 -->
<div class="admin-sidebar">
    <div class="admin-sidebar-logo">
        <h1>살래팔래</h1>
        <p>관리자 모드</p>
    </div>
    
    <div class="admin-sidebar-menu">
        <a href="/admin/home" class="admin-menu-item">
            <svg viewBox="0 0 24 24" fill="white">
                <path d="M10 20v-6h4v6h5v-8h3L12 3 2 12h3v8z"/>
            </svg>
            <span>대시보드</span>
        </a>
        
        <a href="/admin/members" class="admin-menu-item">
            <svg viewBox="0 0 24 24" fill="white">
                <path d="M16 11c1.66 0 2.99-1.34 2.99-3S17.66 5 16 5c-1.66 0-3 1.34-3 3s1.34 3 3 3zm-8 0c1.66 0 2.99-1.34 2.99-3S9.66 5 8 5C6.34 5 5 6.34 5 8s1.34 3 3 3zm0 2c-2.33 0-7 1.17-7 3.5V19h14v-2.5c0-2.33-4.67-3.5-7-3.5zm8 0c-.29 0-.62.02-.97.05 1.16.84 1.97 1.97 1.97 3.45V19h6v-2.5c0-2.33-4.67-3.5-7-3.5z"/>
            </svg>
            <span>회원 관리</span>
        </a>
        
        <a href="/admin/sellerRequest" class="admin-menu-item">
            <svg viewBox="0 0 24 24" fill="white">
                <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/>
            </svg>
            <span>판매 권한 신청</span>
        </a>
        
        <a href="/admin/items" class="admin-menu-item">
            <svg viewBox="0 0 24 24" fill="white">
                <path d="M7 18c-1.1 0-1.99.9-1.99 2S5.9 22 7 22s2-.9 2-2-.9-2-2-2zM1 2v2h2l3.6 7.59-1.35 2.45c-.16.28-.25.61-.25.96 0 1.1.9 2 2 2h12v-2H7.42c-.14 0-.25-.11-.25-.25l.03-.12.9-1.63h7.45c.75 0 1.41-.41 1.75-1.03l3.58-6.49c.08-.14.12-.31.12-.48 0-.55-.45-1-1-1H5.21l-.94-2H1zm16 16c-1.1 0-1.99.9-1.99 2s.89 2 1.99 2 2-.9 2-2-.9-2-2-2z"/>
            </svg>
            <span>물품 관리</span>
        </a>
    </div>
</div>

<!-- 메인 컨텐츠 -->
<div class="main-home">
    <div class="home-container">
        
        <!-- 헤더 -->
        <div class="home-header">
            <div class="home-header-left">
                <h1>관리자 대시보드</h1>
                <p>관리자 로그인 성공! 운영 기능을 선택하세요.</p>
            </div>
            <div class="home-header-right">
                <div class="home-admin-badge">
                    <svg viewBox="0 0 24 24">
                        <path d="M12 1L3 5v6c0 5.55 3.84 10.74 9 12 5.16-1.26 9-6.45 9-12V5l-9-4zm0 10.99h7c-.53 4.12-3.28 7.79-7 8.94V12H5V6.3l7-3.11v8.8z"/>
                    </svg>
                </div>
                <span class="home-admin-name">${loginInfo.username} 관리자님</span>
            </div>
        </div>

        <!-- 통계 카드 -->
        <div class="home-stats">
            <div class="home-stat-card">
                <div class="home-stat-icon orange">
                    <svg viewBox="0 0 24 24">
                        <path d="M16 11c1.66 0 2.99-1.34 2.99-3S17.66 5 16 5c-1.66 0-3 1.34-3 3s1.34 3 3 3zm-8 0c1.66 0 2.99-1.34 2.99-3S9.66 5 8 5C6.34 5 5 6.34 5 8s1.34 3 3 3zm0 2c-2.33 0-7 1.17-7 3.5V19h14v-2.5c0-2.33-4.67-3.5-7-3.5zm8 0c-.29 0-.62.02-.97.05 1.16.84 1.97 1.97 1.97 3.45V19h6v-2.5c0-2.33-4.67-3.5-7-3.5z"/>
                    </svg>
                </div>
                <div class="home-stat-info">
                    <h3>전체 회원</h3>
                    <p id="memberPendingCountText">${listsize }</p>
                </div>
            </div>

            <div class="home-stat-card">
                <div class="home-stat-icon purple">
                    <svg viewBox="0 0 24 24">
                        <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/>
                    </svg>
                </div>
                <div class="home-stat-info">
                    <h3>판매 권한 신청 인원</h3>
                    <p id="pendingCountText" >${slistsize }</p>
                </div>
            </div>

            <div class="home-stat-card">
                <div class="home-stat-icon green">
                    <svg viewBox="0 0 24 24">
                        <path d="M7 18c-1.1 0-1.99.9-1.99 2S5.9 22 7 22s2-.9 2-2-.9-2-2-2zM1 2v2h2l3.6 7.59-1.35 2.45c-.16.28-.25.61-.25.96 0 1.1.9 2 2 2h12v-2H7.42c-.14 0-.25-.11-.25-.25l.03-.12.9-1.63h7.45c.75 0 1.41-.41 1.75-1.03l3.58-6.49c.08-.14.12-.31.12-.48 0-.55-.45-1-1-1H5.21l-.94-2H1zm16 16c-1.1 0-1.99.9-1.99 2s.89 2 1.99 2 2-.9 2-2-.9-2-2-2z"/>
                    </svg>
                </div>
                <div class="home-stat-info">
                    <h3>등록된 물품</h3>
                    <p>8,340</p>
                </div>
            </div>

            <div class="home-stat-card">
                <div class="home-stat-icon blue">
                    <svg viewBox="0 0 24 24">
                        <path d="M19 3h-4.18C14.4 1.84 13.3 1 12 1c-1.3 0-2.4.84-2.82 2H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-7 0c.55 0 1 .45 1 1s-.45 1-1 1-1-.45-1-1 .45-1 1-1zm2 14H7v-2h7v2zm3-4H7v-2h10v2zm0-4H7V7h10v2z"/>
                    </svg>
                </div>
                <div class="home-stat-info">
                    <h3>오늘의 거래</h3>
                    <p>156</p>
                </div>
            </div>
        </div>

        <!-- 메뉴 그리드 -->
        <div class="home-menu-grid">
            <a href="/admin/members" class="home-menu-card">
                <div class="home-menu-icon">
                    <svg viewBox="0 0 24 24">
                        <path d="M16 11c1.66 0 2.99-1.34 2.99-3S17.66 5 16 5c-1.66 0-3 1.34-3 3s1.34 3 3 3zm-8 0c1.66 0 2.99-1.34 2.99-3S9.66 5 8 5C6.34 5 5 6.34 5 8s1.34 3 3 3zm0 2c-2.33 0-7 1.17-7 3.5V19h14v-2.5c0-2.33-4.67-3.5-7-3.5zm8 0c-.29 0-.62.02-.97.05 1.16.84 1.97 1.97 1.97 3.45V19h6v-2.5c0-2.33-4.67-3.5-7-3.5z"/>
                    </svg>
                </div>
                <h3>회원 관리</h3>
                <p>전체 회원 조회 및 관리<br>회원 정보 수정 및 삭제</p>
            </a>

            <a href="/admin/sellerRequest" class="home-menu-card">
                <div class="home-menu-icon">
                    <svg viewBox="0 0 24 24">
                        <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/>
                    </svg>
                </div>
                <h3>판매 권한 신청 관리</h3>
                <p>대기 중인 판매자 신청 승인<br>판매자 등록 관리</p>
            </a>

            <a href="/admin/items" class="home-menu-card">
                <div class="home-menu-icon">
                    <svg viewBox="0 0 24 24">
                        <path d="M7 18c-1.1 0-1.99.9-1.99 2S5.9 22 7 22s2-.9 2-2-.9-2-2-2zM1 2v2h2l3.6 7.59-1.35 2.45c-.16.28-.25.61-.25.96 0 1.1.9 2 2 2h12v-2H7.42c-.14 0-.25-.11-.25-.25l.03-.12.9-1.63h7.45c.75 0 1.41-.41 1.75-1.03l3.58-6.49c.08-.14.12-.31.12-.48 0-.55-.45-1-1-1H5.21l-.94-2H1zm16 16c-1.1 0-1.99.9-1.99 2s.89 2 1.99 2 2-.9 2-2-.9-2-2-2z"/>
                    </svg>
                </div>
                <h3>물품 관리</h3>
                <p>등록된 물품 조회 및 관리<br>부적절한 물품 삭제</p>
            </a>
            
            <a href="/admin/chatList" class="home-menu-card">
                <div class="home-menu-icon" style="background: linear-gradient(135deg, #f1c40f, #e67e22);">
                    <svg viewBox="0 0 24 24">
                        <path d="M20 2H4c-1.1 0-2 .9-2 2v18l4-4h14c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2z"/>
                    </svg>
                </div>
                <h3>채팅 모니터링</h3>
                <p>위험 거래 감지 채팅방 관리<br>실시간 채팅 내역 열람</p>
            </a>
        </div>

    </div>
</div>
<script type="text/javascript">
	$(function() {
	    console.log("초기 판매 승인 대기 수:", "${slistsize}");
	    setInterval(function() {
	        console.log("AJAX 요청: 판매 승인 대기 수 갱신 시도");
	
	        $.ajax({
	            url: "/admin/sellerPendingCount",
	            type: "get",
	            dataType: "json",
	            success: function(data){
	                console.log("서버 응답:", data);
	
	                $("#pendingCountText").text(data.count);
	            },
	            error: function(xhr){
	                console.log("갱신 실패", xhr);
	            }
	        });
	
	    }, 5000);
	});
	
	$(function() {
	    console.log("초기 판매 승인 대기 수:", "${listsize}");
	    setInterval(function() {
	        console.log("AJAX 요청: 판매 승인 대기 수 갱신 시도");
	
	        $.ajax({
	            url: "/admin/memberPendingCount",
	            type: "get",
	            dataType: "json",
	            success: function(data){
	                console.log("서버 응답:", data);
	                $("#memberPendingCountText").text(data.count);
	            },
	            error: function(xhr){
	                console.log("갱신 실패", xhr);
	            }
	        });
	
	    }, 5000); 
	});
</script>

</body>
</html>