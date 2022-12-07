<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%--로그아웃 시도--%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>게시판 웹사이트</title>
</head>
<body>
	<%
		session.invalidate();//로그아웃할 때 세션을 빼앗음.
	%>
	<script>
		location.href = 'main.jsp';
	</script>
</body>
</html>