<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/header.jsp"%>
</head>
<body>

<div class="main-paymentHistory">
    <div class="paymentHistory-container">
        <h1 class="paymentHistory-title">결제 / 적립 내역</h1>
        <p class="paymentHistory-subtitle">포인트 충전, 사용 및 마일리지 적립 내역을 확인하세요</p>

        <!-- 필터 버튼 -->
        <div class="paymentHistory-filter">
            <button class="paymentHistory-filter-btn active" data-filter="ALL">전체</button>
            <button class="paymentHistory-filter-btn" data-filter="CHARGE">충전</button>
            <button class="paymentHistory-filter-btn" data-filter="USE">사용</button>
            <button class="paymentHistory-filter-btn" data-filter="EARN">적립</button>
        </div>

        <!-- 테이블 -->
        <div class="paymentHistory-table-wrapper">
            <table class="paymentHistory-table">
                <thead>
                    <tr>
                        <th>거래일</th>
                        <th>거래 유형</th>
                        <th>금액</th>
                        <th>메모</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="row" items="${historyList}">
                        <tr class="paymentHistory-row"
                            data-history-type="${row.history_type}"
                            data-type="${row.type}">
                            <td>
                                <fmt:formatDate value="${row.created_at}" pattern="yyyy-MM-dd HH:mm"/>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${row.history_type == 'PAY' && row.type == 'CHARGE'}">
                                        <span class="paymentHistory-badge charge">포인트 충전</span>
                                    </c:when>
                                    <c:when test="${row.history_type == 'PAY' && row.type == 'USE'}">
                                        <span class="paymentHistory-badge use">물품 구매</span>
                                    </c:when>
                                    <c:when test="${row.history_type == 'MILEAGE' && row.type == 'EARN'}">
                                        <span class="paymentHistory-badge earn">마일리지 적립</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="paymentHistory-badge gray">기타</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${row.amount > 0}">
                                        <span class="paymentHistory-amount plus">+${row.amount}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="paymentHistory-amount minus">${row.amount}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="paymentHistory-memo">${row.memo}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <!-- 페이지네이션 -->
        <div class="paymentHistory-pagination">
            <c:if test="${pageVO.prev}">
                <a href="?page=${pageVO.startPage - 1}&amount=${pageVO.cri.amount}" class="paymentHistory-page-btn">
                    이전
                </a>
            </c:if>

            <c:forEach var="i" begin="${pageVO.startPage}" end="${pageVO.endPage}">
                <a href="?page=${i}&amount=${pageVO.cri.amount}"
                   class="paymentHistory-page-btn ${pageVO.cri.page == i ? 'active' : ''}">
                    ${i}
                </a>
            </c:forEach>

            <c:if test="${pageVO.next}">
                <a href="?page=${pageVO.endPage + 1}&amount=${pageVO.cri.amount}" class="paymentHistory-page-btn">
                    다음
                </a>
            </c:if>
        </div>
    </div>
</div>

<script>
$(function(){
    console.log("paymentHistory.jsp 로딩 완료");
    console.log("결제 내역 데이터:", ${fn:length(historyList)});

    $(".paymentHistory-filter-btn").on("click", function(){
        const filter = $(this).data("filter");
        console.log("선택된 필터:", filter);

        // 버튼 active 처리
        $(".paymentHistory-filter-btn").removeClass("active");
        $(this).addClass("active");

        $(".paymentHistory-row").each(function(){
            const historyType = $(this).data("history-type");
            const type = $(this).data("type");

            let show = false;

            if (filter === "ALL") {
                show = true;
            }
            else if (filter === "CHARGE") {
                show = (historyType === "PAY" && type === "CHARGE");
            }
            else if (filter === "USE") {
                show = (historyType === "PAY" && type === "USE");
            }
            else if (filter === "EARN") {
                show = (historyType === "MILEAGE" && type === "EARN");
            }

            if (show) {
                $(this).show();
            } else {
                $(this).hide();
            }
        });
    });
});
</script>

<%@ include file="../include/footer.jsp"%>