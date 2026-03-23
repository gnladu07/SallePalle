<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/header.jsp"%>

<c:if test="${!empty msg}">
    <script>alert("${msg}");</script>
</c:if>
<c:if test="${!empty mailMsg}">
    <script>alert("${mailMsg}");</script>
</c:if>

<style>
    .update-btn-auth {
        padding: 12px 20px;
        background: #fff5f4;
        border: 1px solid #FF6F61;
        border-radius: 8px;
        color: #FF6F61;
        font-size: 14px;
        font-weight: 700;
        cursor: pointer;
        white-space: nowrap;
        transition: all 0.3s ease;
    }
    .update-btn-auth:hover {
        background: #FF6F61;
        color: white;
        box-shadow: 0 4px 10px rgba(255, 111, 97, 0.2);
    }
    
    .update-btn-confirm {
        padding: 12px 24px;
        background: linear-gradient(135deg, #FF6F61, #9B59B6);
        border: none;
        border-radius: 8px;
        color: white;
        font-size: 14px;
        font-weight: 700;
        cursor: pointer;
        white-space: nowrap;
        transition: all 0.3s ease;
    }
    .update-btn-confirm:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(255, 111, 97, 0.3);
    }
    
    .auth-input-active {
        border: 2px solid #FF6F61 !important;
        background-color: #fffcfb !important;
    }
</style>

<div class="main-update">
    <div class="update-container">
        <h1 class="update-title">개인정보 수정</h1>
        <p class="update-subtitle">회원 정보를 수정하고 저장하세요</p>

        <form action="/member/update" method="post" id="updateForm">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
            <input type="hidden" id="emailVerified" name="emailVerified" value="false">

            <div class="update-field">
                <label class="update-label">아이디</label>
                <input type="text" 
                       class="update-input update-input-disabled" 
                       name="userid" 
                       id="userid" 
                       value="${loginInfo.userid}" 
                       readonly>
                <div class="update-field-notice">아이디는 변경할 수 없습니다</div>
            </div>

            <div class="update-field">
                <label class="update-label">실명</label>
                <input type="text" 
                       class="update-input update-input-disabled" 
                       name="username" 
                       id="username" 
                       value="${loginInfo.username}" 
                       readonly>
            </div>

            <div class="update-field">
                <label class="update-label">닉네임</label>
                <input type="text" 
                       class="update-input" 
                       name="nickname" 
                       id="nickname" 
                       value="${loginInfo.nickname}" 
                       required>
            </div>

            <div class="update-field">
                <label class="update-label">이메일</label>
                <div class="update-input-row">
                    <input type="email" 
                           class="update-input" 
                           name="email" 
                           id="email" 
                           value="${loginInfo.email}" 
                           placeholder="예) example@naver.com"
                           required>
                    <button type="button" class="update-btn-auth" id="btnEmailAuth">인증번호 받기</button>
                </div>
                <div id="emailMsg" style="margin-top: 8px; font-size: 13px; font-weight: 600;"></div>
            </div>

            <div class="update-field" id="emailCodeDiv" style="display:none; padding-top: 10px;">
                <label class="update-label" style="color: #FF6F61;">인증번호 6자리</label>
                <div class="update-input-row">
                    <input type="text" 
                           class="update-input auth-input-active" 
                           id="emailCode" 
                           placeholder="전송된 인증번호를 입력해주세요">
                    <button type="button" class="update-btn-confirm" id="btnEmailCheck">인증 확인</button>
                </div>
                <div id="emailCodeMsg" style="margin-top: 8px; font-size: 13px; font-weight: 600;"></div>
            </div>

            <div class="update-field">
                <label class="update-label">주소</label>
                <input type="text" 
                       class="update-input" 
                       name="address" 
                       id="address" 
                       value="${loginInfo.address}"
                       placeholder="주소 찾기 (클릭)"
                       readonly
                       required>
            </div>

            <div class="update-field">
                <label class="update-label">상세 주소</label>
                <input type="text" 
                       class="update-input" 
                       name="detail_address" 
                       id="detail_address" 
                       value="${loginInfo.detail_address}"
                       placeholder="상세주소 입력 (예: 봉우아파트 201동 1306호)"
                       required>
            </div>

            <div class="update-button-group">
                <button type="button" class="update-btn update-btn-outline" id="btnCancel">취소</button>
                <button type="button" class="update-btn update-btn-outline" id="btnReset" style="color: #ffc107; border-color: #ffc107;">초기화</button>
                <button type="submit" class="update-btn update-btn-primary">저장하기</button>
            </div>
        </form>
    </div>
</div>

<script>
$(document).ready(function() {
    let emailAuthCode = "";
    let emailVerified = false;

    // 1) 카카오 주소찾기 API
    $("#address").click(function(){
        new daum.Postcode({
            oncomplete: function(data){
                $("#address").val(data.roadAddress);
                $("#detail_address").focus();
            }
        }).open();
    });

    // 2) 이메일 인증번호 받기
    $("#btnEmailAuth").click(function(){
        const email = $("#email").val().trim();
        const emailRegex = /^[A-Za-z0-9_\.\-]+@[A-Za-z0-9\-]+\.[A-Za-z0-9\-]+/;

        if(email === ""){
            alert("이메일을 입력해주세요.");
            $("#email").focus();
            return;
        }
        
        if(!emailRegex.test(email)){
            alert("올바른 이메일 형식으로 입력해주세요. (예: example@gmail.com)");
            $("#email").focus();
            return;
        }

        $.ajax({
            url: "/member/emailCode",
            type: "post",
            data: {
                email: email,
                "${_csrf.parameterName}": "${_csrf.token}"
            },
            success: function(code){
                emailAuthCode = code;
                $("#emailMsg").html("인증번호가 전송되었습니다! 메일함을 확인해주세요.").css("color", "blue");
                $("#emailCodeDiv").slideDown(); // 숨겨진 인증번호 입력칸 부드럽게 표시
                $("#emailCode").focus();
            },
            error: function(xhr){
                console.error("AJAX 오류", xhr);
                alert("서버와 통신에 실패했습니다.");
            }
        });
    });

    // 3) 인증번호 확인
    $("#btnEmailCheck").click(function(){
        const val = $("#emailCode").val().trim();
        
        if(val == emailAuthCode && val !== ""){
            emailVerified = true;
            $("#emailVerified").val("true");
            $("#emailCodeMsg").html("인증이 완료되었습니다.").css("color", "blue");
            
            // 인증 완료 시 테두리 색상 원래대로 원복
            $("#emailCode").removeClass("auth-input-active")
                           .css("border", "1px solid #ddd")
                           .css("background-color", "#f8f9fa")
                           .prop("readonly", true);
            $("#btnEmailCheck").prop("disabled", true).css("background", "#ddd");
        } else {
            emailVerified = false;
            $("#emailVerified").val("false");
            $("#emailCodeMsg").html("인증번호가 일치하지 않습니다.").css("color", "red");
        }
    });

    // 이메일 입력값 변경 시 인증 상태 강제 초기화
    $("#email").on("input", function(){
        $("#emailVerified").val("false");
        $("#emailCodeDiv").slideUp();
        $("#emailCode").val("").prop("readonly", false).addClass("auth-input-active");
        $("#btnEmailCheck").prop("disabled", false).css("background", "linear-gradient(135deg, #FF6F61, #9B59B6)");
        $("#emailMsg").html("");
        $("#emailCodeMsg").html("");
    });

    // 4) 폼 제출 전 최종 검증
    $("#updateForm").submit(function(e){
        const oriEmail = "${loginInfo.email}";
        const newEmail = $("#email").val().trim();
        const verified = $("#emailVerified").val();

        // 기존 이메일과 다르게 변경했는데, 인증을 통과하지 못한 경우 저장을 막음
        if(oriEmail !== newEmail && verified !== "true"){
            alert("이메일이 변경되었습니다. 메일 인증을 먼저 진행해주세요!");
            $("#email").focus();
            e.preventDefault();
            return false;
        }
    });

    // 5) 취소 및 초기화 버튼 로직
    $("#btnCancel").click(function(){
        location.href = "/member/read";
    });

    $("#btnReset").click(function(){
        if(confirm("모든 정보를 저장된 값으로 초기화하시겠습니까?")){
            location.reload();
        }
    });
});
</script>

<%@ include file="../include/footer.jsp"%>