<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h2>판매 권한 신청 목록</h2>
	
	<c:if test="${!empty msgA }">
		<script>
	        alert("${msgA}");
	    </script>
	</c:if>
	<c:if test="${!empty msgR }">
		<script>
	        alert("${msgR}");
	    </script>
	</c:if>

	<c:if test="${empty list}">
	    <p>대기중인 신청이 없습니다.</p>
	</c:if>
	
	<c:if test="${!empty list}">
	<table>
	    <tr>
	        <th>신청번호</th>
	        <th>회원ID</th>
	        <th>닉네임</th>
	        <th>이메일</th>
	        <th>신청일</th>
	        <th>상태</th>
	        <th>관리</th>
	    </tr>
	
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
                        <span class="status-w">대기중</span>
                    </c:when>
                    <c:when test="${req.status == 'A'}">
                        <span class="status-a">승인됨</span>
                    </c:when>
                    <c:when test="${req.status == 'R'}">
                        <span class="status-r">거절됨</span>
                    </c:when>
                </c:choose>
            </td>

            <td>
                <c:if test="${req.status == 'W'}">
                    <form action="/admin/seller/approve" method="post" style="display:inline;">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                        <input type="hidden" name="request_id" value="${req.request_id}">
                        <input type="hidden" name="member_id" value="${req.member_id}">
                        <button class="btn-approve">승인</button>
                    </form>

                    <form action="/admin/seller/reject" method="post" style="display:inline;">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                        <input type="hidden" name="request_id" value="${req.request_id}">
                        <input type="hidden" name="member_id" value="${req.member_id}">
                        <button class="btn-reject">거절</button>
                    </form>
                </c:if>

                <c:if test="${req.status != 'W'}">
                    <span style="color:#555;">처리 완료</span>
                </c:if>
            </td>
        </tr>
    </c:forEach>
	</table>
	</c:if>
</body>
</html>