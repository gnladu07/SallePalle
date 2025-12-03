<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
</head>
<body>
<c:if test="${not empty msg}">
    <script>alert("${msg}");</script>
</c:if>
	<form action="/member/update" method="post">
	<input type="hidden" id="emailVerified" name="emailVerified" value="false">
		<fieldset>
			<label>개인정보 수정</label>
			<div>			
			   <label>닉네임</label>
			   <input type="text" name="nickname" value="${loginInfo.nickname}">
			</div>
			<div>
		    	<label>거주 지역</label>
		        <select name="toplct_id" required>
		            <option value="">-- 지역 선택 --</option>
		            <c:forEach var="loc" items="${topList}">
		                <option value="${loc.toplct_id}">
		                    ${loc.toplct_name}
		                </option>
		            </c:forEach>
		        </select>
		    </div>	
			<div>			
			   <label>상세 주소</label>
			   <input type="text" name="detail_address" id="detail_address" value="${loginInfo.detail_address}">
			</div>
			<div>			
			   <label>이메일</label>
			   <input type="text" name="email" id="email" value="${loginInfo.email}">
			   <button type="button" id="btnEmailAuth">인증번호 받기</button>	
			   <div id="emailMsg"></div>
			</div>
			<div>
		        <input type="text" id="emailCode" placeholder="인증번호 입력">
		        <button type="button" id="btnEmailCheck">확인</button>
		        <div id="emailCodeMsg"></div>
		    </div>
			
			<button type="submit">저장</button>
			<button type="button" id="btnReset">수정 내용 초기화</button>
			<a href="/member/read"><button type="button">뒤로가기</button></a>
		</fieldset>
	</form>
<script type="text/javascript">

	let emailAuthCode = "";
	let emailVerified = false;
	
	// 1) 카카오 주소찾기 API
	$("#detail_address").click(function(){
	    new daum.Postcode({
	        oncomplete: function(data){
	            $("#detail_address").val(data.roadAddress);
	        }
	    }).open();
	});
	
	// 2) 이메일 인증번호 AJAX 요청
	$("#btnEmailAuth").click(function(){
	    const email = $("#email").val().trim();
	
	    if(email.trim() == ""){
	        alert("이메일을 입력해주세요.");
	        return;
	    }
	
	    $.ajax({
	        url: "/member/emailCode",
	        type: "post",
	        data: {email: email},
	        success: function(code){
	            emailAuthCode = code;
	            $("#emailMsg").removeClass().addClass("ok")
	                .html("인증번호가 전송되었습니다.");
	        },
	        error: function(xhr){
	            console.error("AJAX 오류", xhr);
	            alert("서버와 통신에 실패했습니다.");
	        }
	    });
	});

	// 인증번호 확인
	$("#btnEmailCheck").click(function(){
	    const val = $("#emailCode").val();
	
	    if(val == emailAuthCode){
	        emailVerified = true;
	        $("#emailVerified").val("true");
	        $("#emailCodeMsg").html("인증 완료!").addClass("ok").removeClass("no");
	    } else {
	        emailVerified = false;
	        $("#emailVerified").val("false");
	        $("#emailCodeMsg").html("인증번호가 일치하지 않습니다.").addClass("no").removeClass("ok");
	    }
	
	    /* checkJoinReady() */;
	});
	
	// 이메일 바뀔 때 인증필드 강제 false 처리
	$("#email").on("input", function(){
	    $("#emailVerified").val("false");
	});
	
	// “저장” 버튼 누르기 전 검증
	$("form").submit(function(e){
	    const oriEmail = "${loginInfo.email}";
	    const newEmail = $("#email").val().trim();
	    const verified = $("#emailVerified").val();
	
	    // 이메일을 변경했는데 인증이 false라면 → 저장 차단
	    if(oriEmail !== newEmail && verified !== "true"){
	        alert("메일 인증을 진행해주세요!");
	        e.preventDefault();
	        return false;
	    }
	});
	
	// 3) 수정 내용 초기화
	$("#btnReset").click(function(){

	    if(!confirm("모든 정보를 초기값(첫 저장 이력)으로 복구하시겠습니까?")) return;

	    $.ajax({
	        url: "/member/update/reset",
	        type: "post",
	        data: {
	            "${_csrf.parameterName}": "${_csrf.token}"
	        },
	        success: function(){
	            alert("초기값으로 복구되었습니다.");
	            location.reload();
	        },
	        error: function(){
	            alert("복구 중 오류 발생!");
	        }
	    });

	});
</script>
</body>
</html>