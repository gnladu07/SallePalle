<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>판매 권한 신청 관리 - 살래팔래</title>

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

    .admin-menu-item:hover,
    .admin-menu-item.active {
        background: rgba(255,255,255,0.15);
        padding-left: 30px;
    }

    .admin-menu-item svg {
        width: 20px;
        height: 20px;
    }

    /* 메인 컨텐츠 */
    .main-sellerRequest {
        margin-left: 260px;
        padding: 30px 40px;
    }

    .sellerRequest-container {
        max-width: 1400px;
    }

    /* 헤더 */
    .sellerRequest-header {
        background: white;
        padding: 25px 30px;
        border-radius: 15px;
        margin-bottom: 25px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
    }

    .sellerRequest-header h1 {
        font-size: 26px;
        font-weight: 700;
        color: #333;
        margin-bottom: 8px;
    }

    .sellerRequest-header p {
        font-size: 14px;
        color: #888;
    }

    /* 빈 목록 */
    .sellerRequest-empty {
        background: white;
        padding: 60px 40px;
        border-radius: 15px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        text-align: center;
    }

    .sellerRequest-empty-icon {
        width: 80px;
        height: 80px;
        margin: 0 auto 20px;
        border-radius: 50%;
        background: #f8f9fa;
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .sellerRequest-empty-icon svg {
        width: 40px;
        height: 40px;
        fill: #ccc;
    }

    .sellerRequest-empty h3 {
        font-size: 18px;
        color: #666;
        margin-bottom: 8px;
    }

    .sellerRequest-empty p {
        font-size: 14px;
        color: #999;
    }

    /* 테이블 */
    .sellerRequest-table-wrapper {
        background: white;
        border-radius: 15px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        overflow: hidden;
    }

    .sellerRequest-table {
        width: 100%;
        border-collapse: collapse;
    }

    .sellerRequest-table thead {
        background: linear-gradient(135deg, #FF6F61, #9B59B6);
    }

    .sellerRequest-table thead th {
        padding: 15px 12px;
        text-align: left;
        font-size: 13px;
        font-weight: 600;
        color: white;
        white-space: nowrap;
    }

    .sellerRequest-table tbody td {
        padding: 15px 12px;
        font-size: 14px;
        color: #333;
        border-bottom: 1px solid #f0f0f0;
    }

    .sellerRequest-table tbody tr:hover {
        background: #f8f9fa;
    }

    /* 상태 배지 */
    .sellerRequest-status {
        display: inline-block;
        padding: 4px 10px;
        border-radius: 12px;
        font-size: 12px;
        font-weight: 600;
        white-space: nowrap;
    }

    .sellerRequest-status.waiting {
        background: #d1ecf1;
        color: #0c5460;
    }

    .sellerRequest-status.approved {
        background: #d4edda;
        color: #155724;
    }

    .sellerRequest-status.rejected {
        background: #f8d7da;
        color: #721c24;
    }

    /* 버튼 */
    .sellerRequest-action-btn {
        padding: 6px 14px;
        border: none;
        border-radius: 6px;
        font-size: 12px;
        font-weight: 600;
        cursor: pointer;
        transition: 0.2s;
        margin-right: 5px;
    }

    .sellerRequest-action-btn.approve {
        background: #28a745;
        color: white;
    }

    .sellerRequest-action-btn.approve:hover {
        background: #218838;
        transform: translateY(-1px);
    }

    .sellerRequest-action-btn.reject {
        background: #dc3545;
        color: white;
    }

    .sellerRequest-action-btn.reject:hover {
        background: #c82333;
        transform: translateY(-1px);
    }

    .sellerRequest-completed {
        color: #999;
        font-size: 13px;
        font-style: italic;
    }
</style>

</head>
<body>

<c:if test="${!empty msgA}">
    <script>
        alert("${msgA}");
    </script>
</c:if>
<c:if test="${!empty msgR}">
    <script>
        alert("${msgR}");
    </script>
</c:if>

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
        
        <a href="/admin/sellerRequest" class="admin-menu-item active">
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
<div class="main-sellerRequest">
    <div class="sellerRequest-container">
        
        <!-- 헤더 -->
        <div class="sellerRequest-header">
            <h1>판매 권한 신청 관리</h1>
            <p>대기 중인 판매자 신청을 승인하거나 거절할 수 있습니다</p>
        </div>

        <!-- 빈 목록 -->
        <c:if test="${empty list}">
            <div class="sellerRequest-empty">
                <div class="sellerRequest-empty-icon">
                    <svg viewBox="0 0 24 24">
                        <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/>
                    </svg>
                </div>
                <h3>대기중인 신청이 없습니다</h3>
                <p>새로운 판매자 신청이 있으면 여기에 표시됩니다</p>
            </div>
        </c:if>

        <!-- 테이블 -->
        <c:if test="${!empty list}">
            <div class="sellerRequest-table-wrapper">
                <table class="sellerRequest-table">
                    <thead>
                        <tr>
                            <th>신청번호</th>
                            <th>회원ID</th>
                            <th>닉네임</th>
                            <th>이메일</th>
                            <th>신청일</th>
                            <th>상태</th>
                            <th>관리</th>
                        </tr>
                    </thead>

                    <tbody>
                        <c:forEach var="req" items="${list}">
                            <tr>
                                <td>${req.request_id}</td>
                                <td>${req.userid}</td>
                                <td>${req.nickname}</td>
                                <td>${req.email}</td>
                                <td>${req.regdate}</td>

                                <td>
                                    <c:choose>
                                        <c:when test="${req.status == 'W'}">
                                            <span class="sellerRequest-status waiting">대기중</span>
                                        </c:when>
                                        <c:when test="${req.status == 'A'}">
                                            <span class="sellerRequest-status approved">승인됨</span>
                                        </c:when>
                                        <c:when test="${req.status == 'R'}">
                                            <span class="sellerRequest-status rejected">거절됨</span>
                                        </c:when>
                                    </c:choose>
                                </td>

                                <td>
                                    <c:if test="${req.status == 'W'}">
                                        <form action="/admin/seller/approve" method="post" style="display:inline;">
                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                                            <input type="hidden" name="request_id" value="${req.request_id}">
                                            <input type="hidden" name="member_id" value="${req.member_id}">
                                            <button class="sellerRequest-action-btn approve">승인</button>
                                        </form>

                                        <form action="/admin/seller/reject" method="post" style="display:inline;">
                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                                            <input type="hidden" name="request_id" value="${req.request_id}">
                                            <input type="hidden" name="member_id" value="${req.member_id}">
                                            <button class="sellerRequest-action-btn reject">거절</button>
                                        </form>
                                    </c:if>

                                    <c:if test="${req.status != 'W'}">
                                        <span class="sellerRequest-completed">처리 완료</span>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:if>

    </div>
</div>

</body>
</html>