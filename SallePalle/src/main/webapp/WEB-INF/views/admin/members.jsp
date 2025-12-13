<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 관리</title>

<style>

</style>
</head>

<body>
<h2>회원 관리</h2>

<!-- 검색 + 정렬 박스 추가 -->
<div style="margin-bottom:20px; display:flex; gap:20px; align-items:center;">

    <!-- 검색 폼 -->
    <form method="get" action="/admin/members" style="display:flex; gap:10px;">
        <select name="type">
            <option value="userid"   ${param.type == 'userid' ? 'selected' : ''}>아이디</option>
            <option value="username" ${param.type == 'username' ? 'selected' : ''}>이름</option>
            <option value="nickname" ${param.type == 'nickname' ? 'selected' : ''}>닉네임</option>
        </select>

        <input type="text" name="keyword" value="${param.keyword}" placeholder="검색어 입력">

        <button type="submit">검색</button>
    </form>

    <!-- 정렬 드롭다운 -->
    <form id="sortForm" method="get" action="/admin/members">
        <!-- 검색 유지 -->
        <input type="hidden" name="type" value="${param.type}">
        <input type="hidden" name="keyword" value="${param.keyword}">

        <select name="sort" onchange="document.getElementById('sortForm').submit()">
            <option value="regdate"  ${param.sort == 'regdate'  || empty param.sort ? 'selected' : ''}>가입일 최신순</option>
            <option value="disabled" ${param.sort == 'disabled' ? 'selected' : ''}>정지 회원 우선</option>
            <option value="deleted"  ${param.sort == 'deleted'  ? 'selected' : ''}>탈퇴 회원 우선</option>
        </select>
    </form>

</div>

<table class="table">
    <thead>
        <tr>
            <th>ID</th>
            <th>아이디</th>
            <th>이름</th>
            <th>닉네임</th>
            <th>이메일</th>
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

                <!-- 판매 상태 -->
                <td>
                    <c:choose>
                        <c:when test="${m.seller_status == 'Y'}">
                            <span class="badge bg-green">판매자</span>
                        </c:when>
                        <c:when test="${m.seller_status == 'W'}">
                            <span class="badge bg-blue">대기중</span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge bg-gray">일반회원</span>
                        </c:otherwise>
                    </c:choose>
                </td>

                <!-- 활성 상태 -->
                <td>
                    <c:choose>
                        <c:when test="${m.enable_flag == '1'}">
                            <span class="badge bg-green">활성</span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge bg-red">비활성</span>
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
                                <button class="btn btn-warning" type="submit">정지</button>
                            </form>
                        </c:when>

                        <c:otherwise>
                            <form action="/admin/enableMember" method="post" style="display:inline;">
                                <input type="hidden" name="member_id" value="${m.member_id}">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                                <button class="btn btn-green" type="submit">정지 해제</button>
                            </form>
                        </c:otherwise>

                    </c:choose>

                    <c:if test="${m.deleted_at != null or m.enable_flag == '0'}">
                        <form action="/admin/deleteMember" method="post" style="display:inline;">
                            <input type="hidden" name="member_id" value="${m.member_id}">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                            <button class="btn btn-danger" type="submit">삭제</button>
                        </form>
                    </c:if>
                </td>

            </tr>
        </c:forEach>
    </tbody>
</table>
<!-- 페이징 영역 (리스트 아래로 이동) -->
<div style="margin-top:30px;">
    <ul class="pagination" style="display:flex; list-style:none; gap:10px;">

        <c:if test="${pageMaker.prev}">
            <li>
                <a href="?page=${pageMaker.startPage - 1}&sort=${param.sort}&type=${param.type}&keyword=${param.keyword}">
                    이전
                </a>
            </li>
        </c:if>

        <c:forEach var="p" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
            <li style="${p == pageMaker.cri.page ? 'font-weight:bold;' : ''}">
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
</body>
</html>