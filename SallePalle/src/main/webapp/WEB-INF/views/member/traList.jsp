<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/header.jsp" %>

<div class="main-tralist">
    <div class="tralist-container">
        <div class="tralist-header">
            <h1 class="tralist-title">내 등록 물품</h1>
            <p class="tralist-subtitle">판매 중이거나 완료된 상품을 관리하세요</p>
        </div>

        <div class="tralist-table-wrapper">
            <c:choose>
                <c:when test="${empty myTradeList}">
                    <div class="tralist-empty">
                        <svg viewBox="0 0 24 24" fill="#ccc">
                            <path d="M20 6h-2.18c.11-.31.18-.65.18-1a2.996 2.996 0 0 0-5.5-1.65l-.5.67-.5-.68C10.96 2.54 10.05 2 9 2 7.34 2 6 3.34 6 5c0 .35.07.69.18 1H4c-1.11 0-1.99.89-1.99 2L2 19c0 1.11.89 2 2 2h16c1.11 0 2-.89 2-2V8c0-1.11-.89-2-2-2zm-5-2c.55 0 1 .45 1 1s-.45 1-1 1-1-.45-1-1 .45-1 1-1zM9 4c.55 0 1 .45 1 1s-.45 1-1 1-1-.45-1-1 .45-1 1-1zm11 15H4v-2h16v2zm0-5H4V8h5.08L7 10.83 8.62 12 11 8.76l1-1.36 1 1.36L15.38 12 17 10.83 14.92 8H20v6z"/>
                        </svg>
                        <p>등록된 상품이 없습니다</p>
                        <a href="/traBoard/write" class="btn-go-write">상품 등록하러 가기</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <table class="tralist-table">
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
                                    <td>
                                        <span class="tralist-date">${item.regdate}</span>
                                    </td>

                                    <td>
                                        <a href="/traBoard/detail?trade_id=${item.trade_id}" 
                                           class="tralist-title-link">
                                            ${item.title}
                                        </a>
                                    </td>

                                    <td>
                                        <span class="tralist-recommend">
                                            ❤️ ${item.recommend_cnt}
                                        </span>
                                    </td>

                                    <td>
                                        <c:choose>
                                            <c:when test="${item.status eq 'R'}">
                                                <span class="tralist-status status-completed">판매중지</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="tralist-status status-selling">판매중</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td>
                                        <c:if test="${item.status eq 'C'}">
                                            <div class="tralist-actions">
                                                <a href="/traBoard/reupdate?trade_id=${item.trade_id}" 
                                                   class="btn-reupload">
                                                    재등록
                                                </a>

                                                <button class="btn-delete btnDelete"
                                                        data-id="${item.trade_id}">
                                                    삭제
                                                </button>
                                            </div>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

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