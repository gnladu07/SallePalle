<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/header.jsp" %>

<div class="main-join">
    <div class="join-container">

        <h2>중고 상품 재등록</h2>

        <form action="/traBoard/reupdate"
              method="post"
              enctype="multipart/form-data">

            <!-- PK -->
            <input type="hidden" name="trade_id" value="${trade.trade_id}">

            <!-- 기존 썸네일 유지용 -->
            <input type="hidden" name="thumb_img" value="${trade.thumb_img}">
            <input type="hidden" name="detail_img" value="${trade.detail_img}">

            <!-- 상품명 -->
            <div class="join-field">
                <label>상품명</label>
                <input type="text"
                       name="title"
                       value="${trade.title}"
                       required>
            </div>

            <!-- 가격 -->
            <div class="join-field">
                <label>가격 (포인트)</label>
                <input type="number"
                       name="price_point"
                       value="${trade.price_point}"
                       min="0"
                       required>
            </div>

            <!-- 최대 마일리지 -->
            <div class="join-field">
                <label>최대 사용 마일리지</label>
                <input type="number"
                       name="max_mileage_use"
                       value="${trade.max_mileage_use}"
                       min="0">
            </div>

            <!-- 수량 -->
            <div class="join-field">
                <label>수량</label>
                <input type="number"
                       name="quantity"
                       value="${trade.quantity}"
                       min="1">
            </div>

            <!-- 기존 썸네일 미리보기 -->
            <c:if test="${not empty trade.thumb_img}">
                <div class="join-field">
                    <label>현재 썸네일</label><br>
                    <img src="/upload/${trade.thumb_img}"
                         alt="썸네일"
                         style="max-width:200px; border:1px solid #ddd;">
                </div>
            </c:if>

            <!-- 썸네일 수정 -->
            <div class="join-field">
                <label>썸네일 변경 (선택)</label>
                <input type="file"
                       name="thumbFile"
                       accept="image/*">
                <small>※ 새 이미지를 선택하지 않으면 기존 썸네일 유지</small>
            </div>

            <!-- 내용 -->
            <div class="join-field">
                <label>내용</label>
                <textarea name="content"
                          rows="6"
                          required>${trade.content}</textarea>
            </div>

            <!-- 전액 마일리지 허용 -->
            <div class="join-field">
                <label>전액 마일리지 결제</label>
                <select name="allow_full_mileage">
                    <option value="N"
                        <c:if test="${trade.allow_full_mileage eq 'N'}">selected</c:if>>
                        미허용
                    </option>
                    <option value="Y"
                        <c:if test="${trade.allow_full_mileage eq 'Y'}">selected</c:if>>
                        허용
                    </option>
                </select>
            </div>

            <!-- 카테고리 -->
            <div class="join-field">
                <label>상품 종류</label>
                <select name="item_ctg_id">
                    <c:forEach var="ctg" items="${itemCategoryList}">
                        <option value="${ctg.item_ctg_id}"
                            <c:if test="${ctg.item_ctg_id eq trade.item_ctg_id}">selected</c:if>>
                            ${ctg.item_ctg_name}
                        </option>
                    </c:forEach>
                </select>
            </div>

            <!-- 버튼 -->
            <div class="join-field">
                <button type="submit" class="btn btn-primary">
                    재등록하기
                </button>
                <a href="/member/traList" class="btn btn-secondary">
                    취소
                </a>
            </div>

        </form>
    </div>
</div>

<%@ include file="../include/footer.jsp" %>