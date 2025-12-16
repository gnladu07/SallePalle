<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/header.jsp" %>
	<h1>중고 물품 거래 리스트</h1>

	<table border="1">
	    <tr>
	        <th>제목</th>
	        <th>판매자</th>
	        <th>지역</th>
	        <th>가격(포인트)</th>
	        <th>추천</th>
	        <th>등록일</th>
	    </tr>
	
	    <c:forEach var="s" items="${saleTradeList}">
	        <tr>
	            <td>${s.title}</td>
	            <td>${s.seller_nickname}</td>
	            <td>${s.toplct_name}</td>
	            <td>${s.price_point}</td>
	            <td>${s.recommend_cnt}</td>
	            <td>${s.regdate}</td>
	        </tr>
	    </c:forEach>
	</table>

<script>
$(function(){
    console.log("saleTradeList.jsp 로딩 완료");
    console.log("리스트 개수:", "${fn:length(saleTradeList)}");
});
</script>
<%@ include file="../include/footer.jsp" %>