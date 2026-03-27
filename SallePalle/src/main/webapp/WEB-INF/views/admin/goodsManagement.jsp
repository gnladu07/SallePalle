<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
<title>관리자 물품 관리 - 살래팔래</title>
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

    .admin-menu-item:hover, .admin-menu-item.active {
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
    
    /* ==========================================
       추가된 컨텐츠 박스 및 물품 관리 테이블 스타일
       ========================================== */
    .content-box {
        background: white;
        padding: 30px;
        border-radius: 15px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
    }

    .goods-table-wrapper {
        overflow-x: auto;
        border-radius: 12px;
        border: 1px solid #eee;
    }

    .goods-table {
        width: 100%;
        border-collapse: collapse;
        white-space: nowrap;
    }

    .goods-table thead {
        background: linear-gradient(135deg, #FF6F61, #9B59B6);
    }

    .goods-table th {
        padding: 15px 20px;
        text-align: left;
        font-size: 14px;
        font-weight: 600;
        color: white;
    }

    .goods-table td {
        padding: 15px 20px;
        font-size: 14px;
        color: #444;
        border-bottom: 1px solid #eee;
        vertical-align: middle;
    }
    
     /* 검색 & 정렬 박스 */
    .goods-controls {
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

    .goods-search-form {
        display: flex;
        gap: 10px;
        flex: 1;
        min-width: 300px;
    }

    .goods-select {
        padding: 10px 15px;
        border: 1px solid #ddd;
        border-radius: 8px;
        font-size: 14px;
        outline: none;
        transition: 0.2s;
    }

    .goods-select:focus {
        border-color: #FF6F61;
    }

    .goods-input {
        flex: 1;
        padding: 10px 15px;
        border: 1px solid #ddd;
        border-radius: 8px;
        font-size: 14px;
        outline: none;
        transition: 0.2s;
    }

    .goods-input:focus {
        border-color: #FF6F61;
    }

    .goods-btn {
        padding: 10px 20px;
        border: none;
        border-radius: 8px;
        font-size: 14px;
        font-weight: 600;
        cursor: pointer;
        transition: 0.2s;
    }

    .goods-btn-search {
        background: linear-gradient(135deg, #FF6F61, #9B59B6);
        color: white;
    }

    .goods-btn-search:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(255, 111, 97, 0.3);
    }

    .goods-table tbody tr { transition: background 0.2s; }
    .goods-table tbody tr:hover { background: #f8f9fa; }

    .goods-title-link { color: #3498db; text-decoration: none; font-weight: 600; transition: 0.2s; }
    .goods-title-link:hover { color: #2980b9; text-decoration: underline; }

    /* 상태 뱃지 */
    .badge { display: inline-block; padding: 5px 12px; border-radius: 20px; font-size: 12px; font-weight: 600; }
    .badge-sale { background: #e3f2fd; color: #1976d2; }   /* 판매중 */
    .badge-stop { background: #fff3e0; color: #f57c00; }   /* 판매중지 */
    .badge-del { background: #ffebee; color: #c62828; }    /* 삭제됨 */

    .btn-manage { padding: 8px 16px; background: #e0e7ff; color: #4f46e5; border: 1px solid #c7d2fe; border-radius: 8px; font-size: 13px; font-weight: 600; cursor: pointer; transition: 0.2s; }
    .btn-manage:hover { background: #c7d2fe; color: #3730a3; }

    /* ==========================================
       모달(Modal) 창 전용 스타일
       ========================================== */
    .modal-overlay { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 1000; align-items: center; justify-content: center; }
    .modal-content { background: white; padding: 30px; border-radius: 16px; width: 400px; box-shadow: 0 10px 30px rgba(0,0,0,0.2); }
    .modal-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; border-bottom: 1px solid #eee; padding-bottom: 15px; }
    .modal-header h3 { font-size: 18px; color: #333; margin: 0; }
    .close-modal { background: none; border: none; font-size: 24px; cursor: pointer; color: #999; }
    .close-modal:hover { color: #333; }
    
    .modal-form-group { margin-bottom: 20px; }
    .modal-form-group label { display: block; font-size: 14px; font-weight: 600; color: #555; margin-bottom: 8px; }
    .modal-form-group select, .modal-form-group textarea { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 8px; font-family: inherit; font-size: 14px; }
    .modal-form-group textarea { height: 100px; resize: none; }
    .modal-form-group textarea:focus, .modal-form-group select:focus { outline: none; border-color: #FF6F61; }
    
    .modal-btn-group { display: flex; gap: 10px; }
    .modal-btn-group button { flex: 1; padding: 12px; border: none; border-radius: 8px; font-size: 14px; font-weight: 600; cursor: pointer; transition: 0.2s; }
    .btn-cancel { background: #f1f3f5; color: #495057; }
    .btn-cancel:hover { background: #e9ecef; }
    .btn-submit { background: linear-gradient(135deg, #FF6F61, #9B59B6); color: white; }
    .btn-submit:hover { opacity: 0.9; }
</style>
</head>
<body>
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
        
        <a href="/admin/goodsManagement" class="admin-menu-item active">
            <svg viewBox="0 0 24 24" fill="white">
                <path d="M7 18c-1.1 0-1.99.9-1.99 2S5.9 22 7 22s2-.9 2-2-.9-2-2-2zM1 2v2h2l3.6 7.59-1.35 2.45c-.16.28-.25.61-.25.96 0 1.1.9 2 2 2h12v-2H7.42c-.14 0-.25-.11-.25-.25l.03-.12.9-1.63h7.45c.75 0 1.41-.41 1.75-1.03l3.58-6.49c.08-.14.12-.31.12-.48 0-.55-.45-1-1-1H5.21l-.94-2H1zm16 16c-1.1 0-1.99.9-1.99 2s.89 2 1.99 2 2-.9 2-2-.9-2-2-2z"/>
            </svg>
            <span>물품 관리</span>
        </a>
        
        <a href="/admin/chatList" class="admin-menu-item">
            <svg viewBox="0 0 24 24" fill="white">
                <path d="M20 2H4c-1.1 0-2 .9-2 2v18l4-4h14c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2z"/>
            </svg>
            <span>채팅 모니터링</span>
        </a>
    </div>
</div>

<div class="main-home">
    <div class="home-container">
    
        <div class="home-header">
            <div class="home-header-left">
                <h1>🛒 등록 물품 관리</h1>
                <p>등록된 물품을 조회하고 부적절한 게시물을 제재(삭제/판매중지)할 수 있습니다.</p>
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
		<div class="goods-controls">
            <form method="get" action="/admin/goodsManagement" class="goods-search-form">
                <select name="type" class="goods-select">
                    <option value="userid" ${param.type == 'userid' ? 'selected' : ''}>아이디</option>
                    <option value="nickname" ${param.type == 'nickname' ? 'selected' : ''}>닉네임</option>
                    <option value="title" ${param.type == 'title' ? 'selected' : ''}>제목</option>
                    <option value="status" ${param.type == 'status' ? 'selected' : ''}>상태</option>
                </select>

                <input type="text" 
                       name="keyword" 
                       class="goods-input" 
                       value="${param.keyword}" 
                       placeholder="상태는 '판매중', '판매중지', '삭제' 입력">

                <button type="submit" class="goods-btn goods-btn-search">검색</button>
            </form>

            <form id="sortForm" method="get" action="/admin/goodsManagement">
                <input type="hidden" name="type" value="${param.type}">
                <input type="hidden" name="keyword" value="${param.keyword}">

                <select name="sort" class="goods-select" onchange="document.getElementById('sortForm').submit()">
                    <option value="regdate" ${param.sort == 'regdate' || empty param.sort ? 'selected' : ''}>최신등록일순</option>
                    <option value="on_sale" ${param.sort == 'on_sale' ? 'selected' : ''}>판매중</option>
                    <option value="stopped" ${param.sort == 'stopped' ? 'selected' : ''}>판매중지</option>
                </select>
            </form>
        </div>
    
        <div class="content-box">
            <div class="goods-table-wrapper">
                <table class="goods-table">
                    <thead>
                        <tr>
                            <th>등록일</th>
                            <th>ID / 닉네임</th>
                            <th>제목</th>
                            <th>카테고리</th>
                            <th>활성 상태</th>
                            <th>관리</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${goodsList}">
                            <tr>
                                <td><fmt:formatDate value="${item.regdate}" pattern="yyyy-MM-dd HH:mm"/></td>
                                <td>${item.userid} <br> <span style="font-size:12px; color:#888;">(${item.nickname})</span></td>
                                
                                <td style="max-width: 250px; overflow: hidden; text-overflow: ellipsis;">
                                    <a href="/traBoard/detail?trade_id=${item.trade_id}" class="goods-title-link" target="_blank">${item.title}</a>
                                </td>
                                
                                <td>${item.category_name}</td>
                                
                                <td>
                                    <c:choose>
                                        <c:when test="${item.status == 'S' || item.status == 'N'}">
                                            <span class="badge badge-sale">판매중</span>
                                        </c:when>
                                        <c:when test="${item.status == 'R'}">
                                            <span class="badge badge-stop">판매중지</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-del">삭제됨</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                
                                <td>
                                    <c:if test="${item.status != 'D'}">
                                        <button type="button" class="btn-manage" 
                                                onclick="openModal(${item.trade_id}, '${item.seller_email}')">관리하기</button>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty goodsList}">
                            <tr>
                                <td colspan="6" style="text-align:center; padding: 40px; color: #888;">등록된 물품이 없습니다.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
        
    </div>
</div>

<div class="modal-overlay" id="manageModal">
    <div class="modal-content">
        <div class="modal-header">
            <h3>게시물 제재 관리</h3>
            <button class="close-modal" onclick="closeModal()">&times;</button>
        </div>
        <form action="/admin/updateGoodsStatus" method="post" id="manageForm">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
            <input type="hidden" name="trade_id" id="modal_trade_id">
            <input type="hidden" name="seller_email" id="modal_seller_email">
            
            <div class="modal-form-group">
                <label>조치 유형</label>
                <select name="actionType" id="actionType">
                    <option value="STOP">판매 중지 처리</option>
                    <option value="DELETE">게시물 강제 삭제</option>
                </select>
            </div>
            
            <div class="modal-form-group">
                <label>조치 사유 (판매자에게 이메일 발송)</label>
                <textarea name="reason" id="reason" placeholder="부적절한 게시물, 규정 위반 등의 구체적인 사유를 작성해 주세요."></textarea>
            </div>
            
            <div class="modal-btn-group">
                <button type="button" class="btn-cancel" onclick="closeModal()">취소</button>
                <button type="button" class="btn-submit" onclick="submitManage()">적용 및 알림 발송</button>
            </div>
        </form>
    </div>
</div>

<script>
    // 컨트롤러 작업 완료 메시지 알림
    $(document).ready(function() {
        var msg = "${msg}";
        if (msg === "SUCCESS") {
            swal("처리 완료", "물품 상태가 변경되고 메일이 발송되었습니다.", "success");
        }
    });

    // 모달창 열기
    function openModal(trade_id, email) {
        $("#modal_trade_id").val(trade_id);
        $("#modal_seller_email").val(email);
        $("#reason").val(""); 
        $("#manageModal").css("display", "flex");
    }

    // 모달창 닫기
    function closeModal() {
        $("#manageModal").hide();
    }

    // 모달 폼 전송
    function submitManage() {
        if ($("#reason").val().trim() === "") {
            swal("오류", "조치 사유를 반드시 작성해야 합니다.", "warning");
            return;
        }
        
        swal({
            title: "정말 진행하시겠습니까?",
            text: "판매자에게 조치 사유가 이메일로 즉시 발송됩니다.",
            icon: "warning",
            buttons: ["취소", "확인"],
            dangerMode: true,
        }).then((willSubmit) => {
            if (willSubmit) {
                $("#manageForm").submit();
            }
        });
    }
</script>

</body>
</html>