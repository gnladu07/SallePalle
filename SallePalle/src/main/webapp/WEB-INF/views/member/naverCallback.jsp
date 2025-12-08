<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
<script type="text/javascript">
	const userProfile = ${userProfile};   // Controller에서 전달됨
	const providerId  = userProfile.response.id;
	
	const openerPath  = opener.location.pathname;
	const isLoginPage = openerPath.endsWith("/member/login");
	const isJoinPage  = openerPath.endsWith("/member/join");
	
	// 1) 서버에 provider_id로 기존 가입 여부 조회
	fetch("/member/naverLogin", {
	    method: "POST",
	    body: (() => {
	        const f = new FormData();
	        f.append("provider_id", providerId);
	        return f;
	    })()
	})
	.then(resp => resp.json())
	.then(json => {
	
	    // 이미 가입된 계정
	    if (json.success === true) {
	
	    	const resultInput = opener.document.querySelector('input[name="result"]');
            if (resultInput) {
                resultInput.value = JSON.stringify(json);    // 수정됨
            } else {
                alert("오류: 부모창에 result input이 없습니다."); // 수정됨
            }
	
	        window.close();
	        return;
	    }
	
	    // 신규 가입 join.jsp 이동
	    if (!isJoinPage) {
	        opener.location.href = "/member/join";
	    }
	
	    // 부모창이 join.jsp 로딩할 때까지 잠시 대기 후 실행
	    setTimeout(() => {
	
	        const doc = opener.document;
	
	        // 필수 값 채우기
	        doc.querySelector('input[name="username"]').value = userProfile.response.name;
	        doc.querySelector('input[name="nickname"]').value = userProfile.response.nickname;
	        doc.querySelector('input[name="email"]').value    = userProfile.response.email;
	
	        // 성별 (M / F) 확실하게 대입
	        const gender = userProfile.response.gender;   // M 또는 F
	        const genderInput = doc.querySelector(`input[name="gender"][value="${gender}"]`);
	        if (genderInput) {
                genderInput.checked = true;    // 수정됨
            } else {
                console.warn("gender 라디오 버튼을 찾을 수 없습니다."); // 수정됨
            }
	
	        // userid 자동 생성
	        doc.querySelector('input[name="userid"]').value =
	            userProfile.response.email.split("@")[0];
	
	        // provider = NAVER
	        doc.querySelector('input[name="provider"]').value = "NAVER";
	
	        // provider_id
	        doc.querySelector('input[name="provider_id"]').value = providerId;
	
	        // 휴대폰 번호 자동 입력 (네이버 제공 시)
	        if (userProfile.response.mobile) {
	            doc.querySelector('input[name="mobile"]').value =
	                userProfile.response.mobile.replace(/-/g, '-');
	        }
	
	        window.close();
	
	    }, 500);
	
	});
</script>
</body>
</html>