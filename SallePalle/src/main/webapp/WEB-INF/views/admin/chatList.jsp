<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>채팅 모니터링 - 관리자</title>
<style>
    /* [공통] 베이스 레이아웃 */
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body { font-family: 'Noto Sans KR', sans-serif; background: #f5f6fa; }

    /* 사이드바 */
    .admin-sidebar { position: fixed; left: 0; top: 0; width: 260px; height: 100vh; background: linear-gradient(180deg, #FF6F61 0%, #9B59B6 100%); padding: 30px 0; box-shadow: 2px 0 10px rgba(0,0,0,0.1); z-index: 100; }
    .admin-sidebar-logo { text-align: center; padding: 0 20px 30px; border-bottom: 1px solid rgba(255,255,255,0.2); }
    .admin-sidebar-logo h1 { font-size: 28px; font-weight: 800; color: white; margin-bottom: 5px; }
    .admin-sidebar-logo p { font-size: 13px; color: rgba(255,255,255,0.8); font-weight: 500; }
    .admin-sidebar-menu { padding: 30px 0; }
    .admin-menu-item { display: flex; align-items: center; gap: 15px; padding: 15px 25px; color: white; text-decoration: none; font-size: 15px; font-weight: 500; transition: 0.2s; }
    .admin-menu-item:hover, .admin-menu-item.active { background: rgba(255,255,255,0.15); padding-left: 30px; }
    .admin-menu-item svg { width: 20px; height: 20px; }

    /* 메인 컨텐츠 */
    .main-home { margin-left: 260px; padding: 30px 40px; }
    .home-container { max-width: 1400px; }

    /* 헤더 */
    .home-header { background: white; padding: 25px 30px; border-radius: 15px; margin-bottom: 30px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); display: flex; justify-content: space-between; align-items: center; }
    .home-header-left h1 { font-size: 26px; font-weight: 700; color: #333; margin-bottom: 8px; }
    .home-header-left p { font-size: 14px; color: #888; }
    .home-header-right { display: flex; align-items: center; gap: 10px; padding: 12px 20px; background: linear-gradient(135deg, #FF6F61, #9B59B6); border-radius: 25px; }
    .home-admin-badge { width: 35px; height: 35px; border-radius: 50%; background: white; display: flex; align-items: center; justify-content: center; }
    .home-admin-badge svg { width: 20px; height: 20px; fill: #FF6F61; }
    .home-admin-name { color: white; font-size: 14px; font-weight: 600; }

    /* 검색창 & 컨텐츠 영역 */
    .chat-controls { background: white; padding: 20px 25px; border-radius: 15px; margin-bottom: 25px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); display: flex; gap: 20px; align-items: center; flex-wrap: wrap; }
    .chat-search-form { display: flex; gap: 10px; flex: 1; min-width: 300px; }
    .chat-select, .chat-input { padding: 10px 15px; border: 1px solid #ddd; border-radius: 8px; font-size: 14px; outline: none; transition: 0.2s; }
    .chat-select:focus, .chat-input:focus { border-color: #FF6F61; }
    .chat-input { flex: 1; }
    .chat-btn-search { padding: 10px 20px; border: none; border-radius: 8px; font-size: 14px; font-weight: 600; cursor: pointer; transition: 0.2s; background: linear-gradient(135deg, #FF6F61, #9B59B6); color: white; }
    .chat-btn-search:hover { transform: translateY(-2px); box-shadow: 0 4px 12px rgba(255, 111, 97, 0.3); }

    .content-box { background: white; padding: 30px; border-radius: 15px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); }
    .chat-table-wrapper { overflow-x: auto; border-radius: 12px; border: 1px solid #eee; }
    .chat-table { width: 100%; border-collapse: collapse; white-space: nowrap; }
    .chat-table thead { background: linear-gradient(135deg, #FF6F61, #9B59B6); }
    .chat-table th { padding: 15px 20px; text-align: left; font-size: 14px; font-weight: 600; color: white; }
    .chat-table td { padding: 15px 20px; font-size: 14px; color: #444; border-bottom: 1px solid #eee; vertical-align: middle; }
    .chat-table tbody tr { transition: background 0.2s; }
    .chat-table tbody tr:hover { background: #f8f9fa; }

    /* 상태 로우 및 뱃지 */
    .flagged-row { background: #fff0f0 !important; }
    .flagged-row td { color: #d32f2f; font-weight: bold; }
    .closed-row { background: #f0f0f0 !important; }
    .closed-row td { color: #888; }
    .badge { display: inline-block; padding: 5px 12px; border-radius: 6px; font-size: 12px; font-weight: bold; text-align: center; }
    .badge-danger { background: #e74c3c; color: white; }
    .badge-safe { background: #2ecc71; color: white; }
    .badge-closed { background: #7f8c8d; color: white; }

    .btn-view { padding: 8px 16px; background: #e0e7ff; color: #4f46e5; border: 1px solid #c7d2fe; border-radius: 8px; font-size: 13px; font-weight: 600; cursor: pointer; text-decoration: none; display: inline-block; transition: all 0.2s; }
    .btn-view:hover { background: #c7d2fe; color: #3730a3; }
    .text-truncate { max-width: 200px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; display: inline-block; vertical-align: middle; }

    /* 페이지네이션 */
    .chat-pagination { display: flex; justify-content: center; list-style: none; gap: 8px; margin-top: 30px; }
    .chat-pagination li a { display: block; padding: 8px 14px; background: white; border: 1px solid #ddd; border-radius: 8px; color: #666; text-decoration: none; font-size: 14px; font-weight: 500; transition: 0.2s; }
    .chat-pagination li a:hover { border-color: #FF6F61; color: #FF6F61; }
    .chat-pagination li.active a { background: linear-gradient(135deg, #FF6F61, #9B59B6); color: white; border-color: transparent; font-weight: 700; }
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
            <svg viewBox="0 0 24 24" fill="white"><path d="M10 20v-6h4v6h5v-8h3L12 3 2 12h3v8z"/></svg>
            <span>대시보드</span>
        </a>
        <a href="/admin/members" class="admin-menu-item">
            <svg viewBox="0 0 24 24" fill="white"><path d="M16 11c1.66 0 2.99-1.34 2.99-3S17.66 5 16 5c-1.66 0-3 1.34-3 3s1.34 3 3 3zm-8 0c1.66 0 2.99-1.34 2.99-3S9.66 5 8 5C6.34 5 5 6.34 5 8s1.34 3 3 3zm0 2c-2.33 0-7 1.17-7 3.5V19h14v-2.5c0-2.33-4.67-3.5-7-3.5zm8 0c-.29 0-.62.02-.97.05 1.16.84 1.97 1.97 1.97 3.45V19h6v-2.5c0-2.33-4.67-3.5-7-3.5z"/></svg>
            <span>회원 관리</span>
        </a>
        <a href="/admin/sellerRequest" class="admin-menu-item">
            <svg viewBox="0 0 24 24" fill="white"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/></svg>
            <span>판매 권한 신청</span>
        </a>
        <a href="/admin/goodsManagement" class="admin-menu-item">
            <svg viewBox="0 0 24 24" fill="white"><path d="M7 18c-1.1 0-1.99.9-1.99 2S5.9 22 7 22s2-.9 2-2-.9-2-2-2zM1 2v2h2l3.6 7.59-1.35 2.45c-.16.28-.25.61-.25.96 0 1.1.9 2 2 2h12v-2H7.42c-.14 0-.25-.11-.25-.25l.03-.12.9-1.63h7.45c.75 0 1.41-.41 1.75-1.03l3.58-6.49c.08-.14.12-.31.12-.48 0-.55-.45-1-1-1H5.21l-.94-2H1zm16 16c-1.1 0-1.99.9-1.99 2s.89 2 1.99 2 2-.9 2-2-.9-2-2-2z"/></svg>
            <span>물품 관리</span>
        </a>
        <a href="/admin/chatList" class="admin-menu-item active">
            <svg viewBox="0 0 24 24" fill="white"><path d="M20 2H4c-1.1 0-2 .9-2 2v18l4-4h14c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2z"/></svg>
            <span>채팅 모니터링</span>
        </a>
    </div>
</div>

<div class="main-home">
    <div class="home-container">
        <div class="home-header">
            <div class="home-header-left">
                <h1>🚨 실시간 채팅 모니터링</h1>
                <p>위험 거래가 감지된 채팅방을 모니터링하고 추적합니다.</p>
            </div>
            <div class="home-header-right">
                <div class="home-admin-badge">
                    <svg viewBox="0 0 24 24"><path d="M12 1L3 5v6c0 5.55 3.84 10.74 9 12 5.16-1.26 9-6.45 9-12V5l-9-4zm0 10.99h7c-.53 4.12-3.28 7.79-7 8.94V12H5V6.3l7-3.11v8.8z"/></svg>
                </div>
                <span class="home-admin-name">${loginInfo.username} 관리자님</span>
            </div>
        </div>

        <div class="chat-controls">
            <form method="get" action="/admin/chatList" class="chat-search-form">
                <select name="type" class="chat-select">
                    <option value="room_id" ${param.type == 'room_id' ? 'selected' : ''}>방 번호</option>
                    <option value="status" ${param.type == 'status' ? 'selected' : ''}>상태</option>
                    <option value="trade_title" ${param.type == 'trade_title' ? 'selected' : ''}>거래 물품명</option>
                    <option value="seller_name" ${param.type == 'seller_name' ? 'selected' : ''}>판매자명</option>
                    <option value="buyer_name" ${param.type == 'buyer_name' ? 'selected' : ''}>구매자명</option>
                </select>

                <input type="text" 
                       name="keyword" 
                       class="chat-input" 
                       value="${param.keyword}" 
                       placeholder="상태는 '정상', '위험 감지', '해산 완료' 입력">

                <button type="submit" class="chat-btn-search">검색</button>
            </form>

            <form id="sortForm" method="get" action="/admin/chatList">
                <input type="hidden" name="type" value="${param.type}">
                <input type="hidden" name="keyword" value="${param.keyword}">

                <select name="sort" class="chat-select" onchange="document.getElementById('sortForm').submit()">
                    <option value="regdate" ${param.sort == 'regdate' || empty param.sort ? 'selected' : ''}>최신등록일순</option>
                    <option value="normal" ${param.sort == 'normal' ? 'selected' : ''}>정상</option>
                    <option value="flagged" ${param.sort == 'flagged' ? 'selected' : ''}>위험 감지</option>
                    <option value="closed" ${param.sort == 'closed' ? 'selected' : ''}>해산 완료</option>
                </select>
            </form>
        </div>

        <div class="content-box">
            <div class="chat-table-wrapper">
                <table class="chat-table">
                    <thead>
                        <tr>
                            <th>방 번호</th>
                            <th>상태</th>
                            <th>거래 물품명</th>
                            <th>참여자 (구매자 ↔ 판매자)</th>
                            <th>마지막 메시지</th>
                            <th>시간</th>
                            <th>관리</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="room" items="${chatList}">
                            <tr class="${room.admin_closed == 'Y' ? 'closed-row' : (room.is_flagged == 'Y' ? 'flagged-row' : '')}">
                                <td><strong>#${room.room_id}</strong></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${room.admin_closed == 'Y'}">
                                            <span class="badge badge-closed">해산 완료</span>
                                        </c:when>
                                        <c:when test="${room.is_flagged == 'Y'}">
                                            <span class="badge badge-danger">위험 감지</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-safe">정상</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${room.trade_title}</td>
                                <td>${room.buyer_nickname} ↔ ${room.seller_nickname}</td>
                                <td><span class="text-truncate">${room.last_message}</span></td>
                                <td><fmt:formatDate value="${room.last_message_time}" pattern="MM/dd HH:mm"/></td>
                                <td>
                                    <a href="/chat/chatRoom?room_id=${room.room_id}" class="btn-view" target="_blank">열람하기</a>
                                </td>
                            </tr>
                        </c:forEach>
                        
                        <c:if test="${empty chatList}">
                            <tr>
                                <td colspan="7" style="text-align:center; padding: 40px; color: #888;">개설된 채팅방이 없습니다.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>

            <ul class="chat-pagination">
                <c:if test="${pageMaker.prev}">
                    <li><a href="?page=${pageMaker.startPage - 1}&sort=${param.sort}&type=${param.type}&keyword=${param.keyword}">이전</a></li>
                </c:if>
                
                <c:forEach var="p" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
                    <li class="${p == pageMaker.cri.page ? 'active' : ''}">
                        <a href="?page=${p}&sort=${param.sort}&type=${param.type}&keyword=${param.keyword}">${p}</a>
                    </li>
                </c:forEach>
                
                <c:if test="${pageMaker.next}">
                    <li><a href="?page=${pageMaker.endPage + 1}&sort=${param.sort}&type=${param.type}&keyword=${param.keyword}">다음</a></li>
                </c:if>
            </ul>

        </div>
    </div>
</div>

</body>
</html>