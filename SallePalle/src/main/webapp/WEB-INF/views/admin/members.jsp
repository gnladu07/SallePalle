<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 관리 - 살래팔래</title>

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
    .main-members {
        margin-left: 260px;
        padding: 30px 40px;
    }

    .members-container {
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

    /* 검색 & 정렬 박스 */
    .members-controls {
        background: white;
        padding: 20px 25px;
        border-radius: 15px;
        margin-bottom: 25px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        display: flex;
        gap: 20px;
        align-items: center;
        flex-wrap: wrap;
    }

    .members-search-form {
        display: flex;
        gap: 10px;
        flex: 1;
        min-width: 300px;
    }

    .members-select {
        padding: 10px 15px;
        border: 1px solid #ddd;
        border-radius: 8px;
        font-size: 14px;
        outline: none;
        transition: 0.2s;
    }

    .members-select:focus {
        border-color: #FF6F61;
    }

    .members-input {
        flex: 1;
        padding: 10px 15px;
        border: 1px solid #ddd;
        border-radius: 8px;
        font-size: 14px;
        outline: none;
        transition: 0.2s;
    }

    .members-input:focus {
        border-color: #FF6F61;
    }

    .members-btn {
        padding: 10px 20px;
        border: none;
        border-radius: 8px;
        font-size: 14px;
        font-weight: 600;
        cursor: pointer;
        transition: 0.2s;
    }

    .members-btn-search {
        background: linear-gradient(135deg, #FF6F61, #9B59B6);
        color: white;
    }

    .members-btn-search:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(255, 111, 97, 0.3);
    }

    /* 테이블 */
    .members-table-wrapper {
        background: white;
        border-radius: 15px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        overflow: hidden;
    }

    .members-table {
        width: 100%;
        border-collapse: collapse;
    }

    .members-table thead {
        background: linear-gradient(135deg, #FF6F61, #9B59B6);
    }

    .members-table thead th {
        padding: 15px 12px;
        text-align: left;
        font-size: 13px;
        font-weight: 600;
        color: white;
        white-space: nowrap;
    }

    .members-table tbody td {
        padding: 15px 12px;
        font-size: 14px;
        color: #333;
        border-bottom: 1px solid #f0f0f0;
    }

    .members-table tbody tr:hover {
        background: #f8f9fa;
    }

    /* 배지 */
    .members-badge {
        display: inline-block;
        padding: 4px 10px;
        border-radius: 12px;
        font-size: 12px;
        font-weight: 600;
        white-space: nowrap;
    }

    .members-badge.green {
        background: #d4edda;
        color: #155724;
    }

    .members-badge.blue {
        background: #d1ecf1;
        color: #0c5460;
    }

    .members-badge.gray {
        background: #e2e3e5;
        color: #6c757d;
    }

    .members-badge.red {
        background: #f8d7da;
        color: #721c24;
    }

    /* 버튼 */
    .members-action-btn {
        padding: 6px 12px;
        border: none;
        border-radius: 6px;
        font-size: 12px;
        font-weight: 600;
        cursor: pointer;
        transition: 0.2s;
        margin-right: 5px;
    }

    .members-action-btn.warning {
        background: #ffc107;
        color: white;
    }

    .members-action-btn.warning:hover {
        background: #e0a800;
    }

    .members-action-btn.success {
        background: #28a745;
        color: white;
    }

    .members-action-btn.success:hover {
        background: #218838;
    }

    .members-action-btn.danger {
        background: #dc3545;
        color: white;
    }

    .members-action-btn.danger:hover {
        background: #c82333;
    }

    /* 페이지네이션 */
    .members-pagination {
        display: flex;
        justify-content: center;
        gap: 8px;
        list-style: none;
        margin-top: 30px;
        padding: 0;
    }

    .members-pagination li a {
        display: block;
        padding: 8px 14px;
        border: 1px solid #ddd;
        border-radius: 6px;
        color: #333;
        text-decoration: none;
        font-size: 14px;
        transition: 0.2s;
    }

    .members-pagination li a:hover {
        background: #FF6F61;
        color: white;
        border-color: #FF6F61;
    }

    .members-pagination li.active a {
        background: linear-gradient(135deg, #FF6F61, #9B59B6);
        color: white;
        border-color: transparent;
        font-weight: 700;
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
        
        <a href="/admin/members" class="admin-menu-item active">
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
<div class="main-members">
    <div class="members-container">
        
        <!-- 헤더 -->
        <div class="home-header">
            <div class="home-header-left">
                <h1>🤝 회원 관리</h1>
            	<p>전체 회원 조회 및 관리, 회원 정지/삭제, 권한 관리</p>
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

        <!-- 검색 & 정렬 -->
        <div class="members-controls">
            <!-- 검색 폼 -->
            <form method="get" action="/admin/members" class="members-search-form">
                <select name="type" class="members-select">
                    <option value="userid" ${param.type == 'userid' ? 'selected' : ''}>아이디</option>
                    <option value="username" ${param.type == 'username' ? 'selected' : ''}>이름</option>
                    <option value="nickname" ${param.type == 'nickname' ? 'selected' : ''}>닉네임</option>
                </select>

                <input type="text" 
                       name="keyword" 
                       class="members-input" 
                       value="${param.keyword}" 
                       placeholder="검색어 입력">

                <button type="submit" class="members-btn members-btn-search">검색</button>
            </form>

            <!-- 정렬 드롭다운 -->
            <form id="sortForm" method="get" action="/admin/members">
                <input type="hidden" name="type" value="${param.type}">
                <input type="hidden" name="keyword" value="${param.keyword}">

                <select name="sort" class="members-select" onchange="document.getElementById('sortForm').submit()">
                    <option value="regdate" ${param.sort == 'regdate' || empty param.sort ? 'selected' : ''}>가입일 최신순</option>
                    <option value="disabled" ${param.sort == 'disabled' ? 'selected' : ''}>정지 회원 우선</option>
                    <option value="deleted" ${param.sort == 'deleted' ? 'selected' : ''}>탈퇴 회원 우선</option>
                </select>
            </form>
        </div>

        <!-- 테이블 -->
        <div class="members-table-wrapper">
            <table class="members-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>아이디</th>
                        <th>이름</th>
                        <th>닉네임</th>
                        <th>이메일</th>
                        <th>살래P</th>
                        <th>팔래M</th>
                        <th>판매 권한</th>
                        <th>활성 상태</th>
                        <th>가입일</th>
                        <th>탈퇴일</th>
                        <th>관리</th>
                    </tr>
                </thead>

                <tbody>
                    <c:forEach var="m" items="${memberList}">
                        <tr>
                            <td>${m.member_id}</td>
                            <td>${m.userid}</td>
                            <td>${m.username}</td>
                            <td>${m.nickname}</td>
                            <td>${m.email}</td>
                            <td>${m.wallet_balance}</td>
                            <td>${m.wallet_mileage}</td>
                            
                            <!-- 판매 상태 -->
                            <td>
                                <c:choose>
                                    <c:when test="${m.seller_status == 'Y'}">
                                        <span class="members-badge green">판매자</span>
                                    </c:when>
                                    <c:when test="${m.seller_status == 'W'}">
                                        <span class="members-badge blue">대기중</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="members-badge gray">일반회원</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>

                            <!-- 활성 상태 -->
                            <td>
                                <c:choose>
                                    <c:when test="${m.enable_flag == '1'}">
                                        <span class="members-badge green">활성</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="members-badge red">비활성</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>

                            <td>${m.regdate}</td>
                            <td>${m.deleted_at}</td>

                            <td>
                                <!-- 정지 / 정지 해제 버튼 -->
                                <c:choose>
                                    <c:when test="${m.enable_flag == '1'}">
                                        <form action="/admin/disableMember" method="post" style="display:inline;">
                                            <input type="hidden" name="member_id" value="${m.member_id}">
                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                                            <button class="members-action-btn warning" type="submit">정지</button>
                                        </form>
                                    </c:when>
                                    <c:otherwise>
                                        <form action="/admin/enableMember" method="post" style="display:inline;">
                                            <input type="hidden" name="member_id" value="${m.member_id}">
                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                                            <button class="members-action-btn success" type="submit">정지 해제</button>
                                        </form>
                                    </c:otherwise>
                                </c:choose>

                                <c:if test="${m.deleted_at != null or m.enable_flag == '0'}">
                                    <form action="/admin/deleteMember" method="post" style="display:inline;">
                                        <input type="hidden" name="member_id" value="${m.member_id}">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                                        <button class="members-action-btn danger" type="submit">삭제</button>
                                    </form>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <!-- 페이지네이션 -->
        <ul class="members-pagination">
            <c:if test="${pageMaker.prev}">
                <li>
                    <a href="?page=${pageMaker.startPage - 1}&sort=${param.sort}&type=${param.type}&keyword=${param.keyword}">
                        이전
                    </a>
                </li>
            </c:if>

            <c:forEach var="p" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
                <li class="${p == pageMaker.cri.page ? 'active' : ''}">
                    <a href="?page=${p}&sort=${param.sort}&type=${param.type}&keyword=${param.keyword}">
                        ${p}
                    </a>
                </li>
            </c:forEach>

            <c:if test="${pageMaker.next}">
                <li>
                    <a href="?page=${pageMaker.endPage + 1}&sort=${param.sort}&type=${param.type}&keyword=${param.keyword}">
                        다음
                    </a>
                </li>
            </c:if>
        </ul>

    </div>
</div>

</body>
</html>