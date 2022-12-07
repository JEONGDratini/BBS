<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%--글쓰기 화면--%>
<%@ page import="java.io.PrintWriter" %> <%-- 자바스크립트 문장을 쓰기 위해서 사용한다. --%>
<%@ page import="bbs.Bbs" %>
<%@ page import="bbs.BbsDB_Access" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%--접속 기기 화면크기에 따라 달라지는 인터페이스--%>
<meta name="viewport" content="width=device-width", initial-scale="1">
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/my_own_custom.css">
<title>게시판 웹사이트</title>
</head>
<body>
	<%
	String userID = null;
	if(session.getAttribute("userID") != null) {//현재 세션에 있는 회원들의 세션 값을 저장한다.
		userID = (String)session.getAttribute("userID");
	}
	if(userID == null) {//로그인 여부
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인을 하세요')");
		script.println("location.href = 'bbs.jsp'");
		script.println("</script>");
	}
	int bbsID = 0; //출력 전 기본설정
	if(request.getParameter("bbsID") != null) {
		bbsID = Integer.parseInt(request.getParameter("bbsID"));//bbsID 파라미터를 받아온다.
	}
	
	if(bbsID == 0) {//파라미터를 못받아왔으면 조회X
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('유효하지 않은 글입니다.')");
		script.println("location.href = 'bbs.jsp'");
		script.println("</script>");
	}
	Bbs bbs = new BbsDB_Access().getBbs(bbsID);//bbsID로 DB를 조회한 결과를 bbs객체에 집어넣는다.
	if(!userID.equals(bbs.getUserID())){//글쓴이랑 수정하려는 사람이 같은지 확인. 다르면 권한 없다고 함.
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('권한이 없습니다.')");
		script.println("location.href = 'bbs.jsp'");
		script.println("</script>");
	}
	
	%>
	<nav class="navbar navbar-default"><%--페이지의 전체적인 구성 보여주는 메뉴--%>
		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapsed"
			data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
			aria-expanded="false"><%--출력할 화면이 기본 사이트 크기보다 작을경우에 출력하도록 함.--%>
			<span class="icon-bar"></span><%--줄었을 때 나오는 작대기 갯수를 말한다.--%>
			<span class="icon-bar"></span>
			<span class="icon-bar"></span>
			</button>
			<a class="navbar-brand" href="main.jsp">JSP게시판 웹사이트</a>
		</div>
		<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li><a href="main.jsp">메인</a></li> <%-- active 클래스는 현재 접속되어있는 페이지가 main이라고 알려준다. --%>
				<li class="active"><a href="bbs.jsp">게시판</a></li>
			</ul>
			
			<ul class="nav navbar-nav navbar-right">
				<li class = "dropdown">
					<a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expanded="false">회원관리<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="logoutExecute.jsp">로그아웃</a></li>
					</ul>
				</li>
			</ul>			
	
		</div>
	</nav>
	<div class="container"> <%-- 게시글 표기되는 부분 --%>
		<div class="row"> <%-- 게시글을 행으로 나뉘는 표로 나눠서 표기. --%>
		<form method="post" action="updateExecute.jsp?bbsID=<%= bbsID %>"><%-- 데이터를 어디로(action) 전송할지 어떻게(post) 전송할지를 설정한다. --%>
			<table class="table table-striped" style="text-align: center; border:1px solid #dddddd"><%-- 테이플 홀수짝수 색상구별 및 회색테두리--%>
				<thead><%-- table의 제목. 각 속성을 정의.  --%>
					<tr><%-- 1줄 --%>
						<th colspan="2" style="background-color:#eeeeee; text-align: center">게시판 글 수정 양식</th>
					</tr>
				</thead>
				<tbody>
						<%-- input은 데이터를 액션페이지로 보낼 때 사용한다. --%>
					<tr>
						<td><input type="text" class="form-control" placeholder="글 제목" name="bbsTitle" maxlength="50" value="<%= bbs.getBbsTitle() %>"></td>
					</tr>
					<tr>
						<td><textarea class="form-control" placeholder="글 내용" name="bbsContent" maxlength="4096" style="height: 300px;"><%= bbs.getBbsContent() %></textarea></td>
					</tr>
				</tbody>		
			</table>
			<input type="submit" class="btn btn-primary pull-right" value="수정"><%--내용을 보낼 때 사용할 submit버튼 --%>
		</form>
		</div>
	</div>
	
	
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
	
</body>
</html>