<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/header.jsp"%>
<div class="main-home">
    <div class="main-inner">

        <!-- 검색 -->
        <div class="search-box">
            <input type="text" placeholder="찾고 싶은 물건을 검색해보세요">
        </div>

        <!-- 카테고리 -->
        <div class="category">
            <button>전체</button>
            <button>디지털</button>
            <button>생활가전</button>
            <button>의류</button>
            <button>취미 / 게임</button>
            <button>가구 / 인테리어</button>
            <button>스포츠</button>
            <button>식료품</button>
            <button>공구</button>
        </div>

        <!-- 게시물 리스트 -->
        <div id="post-list" class="post-list">
            <!-- 기본 카드 6개 미리 로딩 -->
        </div>

    </div>
</div>
<script>

</script>
<%@ include file="../include/footer.jsp"%>
