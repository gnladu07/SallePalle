<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../main/header.jsp"%>
<body>
<div class="main-joinChoice">
    <div class="join-container">
        <h1 class="join-title">회원가입</h1>
        <p class="join-subtitle">살래팔래와 함께 시작하세요</p>

        <div class="join-options">
            <!-- 살래팔래 자체 회원가입 -->
            <button class="join-option-btn primary" onclick="location.href='join.jsp'">
                <svg class="icon" fill="white" viewBox="0 0 24 24">
                    <path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/>
                </svg>
                이메일로 회원가입
            </button>

            <div class="divider">또는</div>

            <!-- 네이버 간편 로그인 -->
            <button id="loginWithNaver" class="join-option-btn naver" >
                <svg class="icon" fill="white" viewBox="0 0 24 24">
                    <path d="M16.273 12.845L7.376 0H0v24h7.726V11.156L16.624 24H24V0h-7.727v12.845z"/>
                </svg>
                네이버로 간편 가입
            </button>
        </div>

        <div class="login-link">
            이미 계정이 있으신가요? <a href="login.jsp">로그인</a>
        </div>
        <input type="hidden" name="result">
    </div>
</div>
<script type="text/javascript">
$(function() {

    // 네이버 로그인 버튼 클릭
    $('#loginWithNaver').on('click', function(e) {
        e.preventDefault();

        const url = '${naverLoginURL}';
        const name = '_blank';
        const options = 'menubar=no, toolbar=no, width=700, height=1000';

        const popup = window.open(url, name, options);

        // 팝업 닫힘 감지
        const timer = setInterval(function() {
            if (popup.closed) {
                clearInterval(timer);
                afterClosePopup();
            }
        }, 1000);
    });


    // 팝업 닫힌 후 처리
    function afterClosePopup() {

        const json = $('input[name="result"]').val();

        if (!json || json.trim() === "") {
            console.warn("네이버 callback 값이 없음");
            return;
        }

        const result = JSON.parse(json);
        console.log(result);

        // 기존회원이면 자동 로그인
        if (result.success === true) {
            location.href = '/main/header';
            return;
        }

        // 신규회원이면 회원가입 안내
        if (result.success === false) {
            swal({
                title: '연동된 계정이 없습니다',
                text: '회원가입으로 이동합니다',
                icon: 'info',
                buttons: true
            }).then((isConfirm) => {
                if (isConfirm) {
                    location.href = '/member/join';
                }
            });
        }
    }

});
</script>
</body>
</html>