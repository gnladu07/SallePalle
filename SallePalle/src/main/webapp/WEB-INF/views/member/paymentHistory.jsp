<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/header.jsp"%>
</head>
<body>

<div class="main-paymentHistory">
    <div class="paymentHistory-container">
        <h1 class="paymentHistory-title">결제 / 적립 내역</h1>
        <p class="paymentHistory-subtitle">
            포인트 충전, 사용 및 마일리지 적립 내역을 확인하세요
        </p>

        <!-- 필터 버튼 -->
        <div class="paymentHistory-filter">
            <button class="paymentHistory-filter-btn active" data-filter="ALL">전체</button>
            <button class="paymentHistory-filter-btn" data-filter="CHARGE">충전</button>
            <button class="paymentHistory-filter-btn" data-filter="EARN">적립</button>
            <button class="paymentHistory-filter-btn" data-filter="BUY">구매</button>
            <button class="paymentHistory-filter-btn" data-filter="SELL">판매</button>
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
                    <c:forEach var="row" items="${walletList}">
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
                                        <span class="paymentHistory-badge use">포인트 사용</span>
                                    </c:when>
                                    <c:when test="${row.history_type == 'MILEAGE' && row.type == 'EARN'}">
                                        <span class="paymentHistory-badge earn">마일리지 적립</span>
                                    </c:when>
                                    <c:when test="${row.history_type == 'BUY'}">
                                        <span class="paymentHistory-badge use">상품 구매</span>
                                    </c:when>
                                    <c:when test="${row.history_type == 'SELL'}">
                                        <span class="paymentHistory-badge earn">판매 수익</span>
                                    </c:when>
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
    </div>
</div>

<script>
$(function(){

    $(".paymentHistory-filter-btn").on("click", function(){
        
    	const filter = $(this).data("filter");
    	console.log("선택된 필터:", filter);
    	
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
            else if (filter === "EARN") {
                show = (historyType === "MILEAGE" && type === "EARN");
            }
            else if (filter === "BUY") {
                show = (historyType === "BUY");
            }
            else if (filter === "SELL") {
                show = (historyType === "SELL");
            }

            $(this).toggle(show);
        });
    });
});
</script>

<%@ include file="../include/footer.jsp"%>