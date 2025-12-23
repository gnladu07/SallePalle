<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/header.jsp" %>

<h2>내 등록 물품</h2>

<table border="1" width="100%">
    <thead>
        <tr>
            <th>등록일</th>
            <th>제목</th>
            <th>추천 수</th>
            <th>판매 상태</th>
            <th>관리</th>
        </tr>
    </thead>
    <tbody>
        <c:forEach var="item" items="${myTradeList}">
            <tr>
                <td>${item.regdate}</td>

                <td>
                    <a href="/traBoard/detail?trade_id=${item.trade_id}">
                        ${item.title}
                    </a>
                </td>

                <td>${item.recommend_cnt}</td>

                <td>
                    <c:choose>
                        <c:when test="${item.status eq 'C'}">판매완료</c:when>
                        <c:otherwise>판매중</c:otherwise>
                    </c:choose>
                </td>

                <td>
                    <c:if test="${item.status eq 'C'}">
                        <a href="/traBoard/reupdate?trade_id=${item.trade_id}">재등록</a>

                        <button class="btnDelete"
                                data-id="${item.trade_id}">
                            삭제
                        </button>
                    </c:if>
                </td>
            </tr>
        </c:forEach>
    </tbody>
</table>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
$(function () {

    $(".btnDelete").on("click", function () {
        var tradeId = $(this).data("id");
        console.log("삭제 클릭 tradeId =", tradeId);

        if (!confirm("해당 판매글을 삭제하시겠습니까?")) return;

        $.ajax({
            url: "/member/deleteTrade",
            type: "post",
            data: { trade_id: tradeId },
            /* beforeSend: function (xhr) {
                xhr.setRequestHeader(
                    "${_csrf.headerName}",
                    "${_csrf.token}"
                );
            }, */
            success: function (res) {
                console.log("삭제 결과 =", res);
                if (res === "OK") {
                    location.reload();
                }
            }
        });
    });

});
</script>

<%@ include file="../include/footer.jsp" %>