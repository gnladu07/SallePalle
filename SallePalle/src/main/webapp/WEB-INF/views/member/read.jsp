<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/header.jsp"%>
<c:if test="${empty loginInfo}">
    <script>
        alert("로그인이 필요합니다.");
        location.href='/member/login';
    </script>
</c:if>
<c:if test="${!empty imageMsg}">
    <script>alert("${imageMsg}");</script>
</c:if>
<c:if test="${!empty msg}">
    <script>alert("${msg}");</script>
</c:if>

<div class="main-read">
    <div class="read-container">
        <h1 class="read-title">내 정보</h1>
        <p class="read-subtitle">회원 정보를 확인하고 관리하세요</p>

        <!-- 프로필 섹션 -->
        <div class="read-profile-section">
            <div class="read-profile-img-wrapper">
                <img src="/upload/${loginInfo.profile_img}" class="read-profile-img" alt="프로필">
            </div>
            <a href="/member/profileEdit" class="read-profile-edit-btn">
                <svg class="icon" fill="white" viewBox="0 0 24 24">
                    <path d="M3 17.25V21h3.75L17.81 9.94l-3.75-3.75L3 17.25zM20.71 7.04c.39-.39.39-1.02 0-1.41l-2.34-2.34c-.39-.39-1.02-.39-1.41 0l-1.83 1.83 3.75 3.75 1.83-1.83z"/>
                </svg>
                프로필 변경
            </a>
        </div>

        <!-- 회원 정보 카드 -->
        <div class="read-info-cards">
            <div class="read-info-card">
                <div class="read-info-label">아이디</div>
                <div class="read-info-value">${loginInfo.userid}</div>
            </div>
            
            <div class="read-info-card">
                <div class="read-info-label">실명</div>
                <div class="read-info-value">${loginInfo.username}</div>
            </div>
            
            <div class="read-info-card">
                <div class="read-info-label">닉네임</div>
                <div class="read-info-value">${loginInfo.nickname}</div>
            </div>
            
            <div class="read-info-card">
                <div class="read-info-label">이메일</div>
                <div class="read-info-value">${loginInfo.email}</div>
            </div>
            
            <div class="read-info-card">
                <div class="read-info-label">휴대폰 번호</div>
                <div class="read-info-value">${loginInfo.mobile}</div>
            </div>
            
            <div class="read-info-card">
                <div class="read-info-label">생년월일</div>
                <div class="read-info-value">${loginInfo.birth6}</div>
            </div>
            
            <div class="read-info-card">
                <div class="read-info-label">성별</div>
                <div class="read-info-value">
                    ${loginInfo.gender == 'M' ? '남자' : '여자'}
                </div>
            </div>
            
            <div class="read-info-card read-info-card-wide">
			    <div class="read-info-label">주소</div>
			    <div class="read-info-value">${loginInfo.address} ${loginInfo.detail_address}</div>
			</div>
        </div>

        <!-- 버튼 그룹 -->
        <div class="read-button-group">
            <a href="/member/update" class="read-btn read-btn-primary">
                회원정보 수정
            </a>
            <button type="button" class="read-btn read-btn-secondary" id="btnDeleteOpen">
                회원탈퇴
            </button>
            <a href="/main/home" class="read-btn read-btn-outline">
                홈으로
            </a>
        </div>
    </div>
</div>

<!-- 탈퇴 모달 -->
<div id="deleteModal" class="read-modal">
    <div class="read-modal-content">
        <h3 class="read-modal-title">회원 탈퇴</h3>
        <p class="read-modal-subtitle">비밀번호를 입력하여 본인 확인을 진행해주세요</p>
        
        <input type="password" 
               id="userpw" 
               class="read-modal-input" 
               placeholder="비밀번호 입력">
        
        <div class="read-modal-buttons">
            <button type="button" class="read-modal-btn read-modal-btn-confirm" id="btnCheckPw">
                확인
            </button>
            <button type="button" class="read-modal-btn read-modal-btn-cancel" id="btnCloseModal">
                취소
            </button>
        </div>
    </div>
</div>
<script type="text/javascript">
	var updateInfo = '${updateInfo}';
	
	if(updateInfo == "success") {
		alert("회원 정보가 수정되었습니다.")
	}
	
	/* 모달 열기 */
	$("#btnDeleteOpen").click(function(){
	    $("#deleteModal").css("display", "flex");
	});

	/* 모달 닫기 */
	$("#btnCloseModal").click(function(){
	    $("#deleteModal").hide();
	});

	/* 비밀번호 체크 */
	$("#btnCheckPw").click(function(){

	    const pw = $("#userpw").val().trim();

	    if(pw === ""){
	        alert("비밀번호를 입력해주세요.");
	        return;
	    }

	    $.ajax({
	        url: "/member/checkPw",
	        type: "post",
	        data: {
	            userpw: pw,
	            "${_csrf.parameterName}": "${_csrf.token}"
	        },
	        success: function(result){

	            if(result === "ok"){
	                if(confirm("정말로 탈퇴하시겠습니까?")){
	                    deleteAccount();
	                }
	            } else {
	                alert("비밀번호가 일치하지 않습니다.");
	            }
	        },
	        error: function(){
	            alert("서버 오류 발생");
	        }
	    });
	});

	/* 실제 탈퇴 AJAX */
	function deleteAccount(){

	    $.ajax({
	        url: "/member/delete",
	        type: "post",
	        data: {
	            "${_csrf.parameterName}": "${_csrf.token}"
	        },
	        success: function(result){
	            alert("회원 탈퇴가 완료되었습니다.");
	            location.href="/";
	        },
	        error: function(){
	            alert("탈퇴 처리 중 오류 발생");
	        }
	    });

	}
</script>
<%@ include file="../include/footer.jsp"%>