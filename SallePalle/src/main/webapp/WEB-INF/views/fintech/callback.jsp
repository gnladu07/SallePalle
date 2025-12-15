<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<title>포인트 충전 완료</title>
</head>
<body>

<script>
    $(function(){

        console.log("callback.jsp 로딩됨");

        const msg = "${msg}";
        console.log("수신된 메시지:", msg);

        alert(msg);

        // 홈으로 이동
        window.location.href = "/main/home";
    });
</script>

</body>
</html>