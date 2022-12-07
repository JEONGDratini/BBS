<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%--글쓰기 화면--%>
<%@ page import="java.io.PrintWriter" %> <%-- 자바스크립트 문장을 쓰기 위해서 사용한다. --%>
<%@ page import="bbs.BbsDB_Access" %> <%-- 게시판 DB에 접속하기 위해서 사용한다. 게시물 출력을 위해서 사용.--%>
<%@ page import="bbs.Bbs" %> <%-- 게시판 DB에 접속하기 위해서 사용한다. 게시물 출력을 위해서 사용.--%>
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
	
	int bbsID = 0; //출력 전 기본설정
	if(request.getParameter("bbsID") != null) {
		bbsID = Integer.parseInt(request.getParameter("bbsID"));//bbsID 파라미터를 받아온다.
	}
	
	if(bbsID == 0) {//파라미터를 못받아왔으면 조회X
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('조회할 수 없는 게시글입니다.')");
		script.println("location.href = 'bbs.jsp'");
		script.println("</script>");
	}
	Bbs bbs = new BbsDB_Access().getBbs(bbsID);//bbsID로 DB를 조회한 결과를 bbs객체에 집어넣는다.
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
			<%
			if(userID == null) {  //로그인이 되어있지 않을 때에만 보이도록 함.
			%>
			<ul class="nav navbar-nav navbar-right">
				<li class = "dropdown">
					<a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expanded="false">로그인<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="Login.jsp">로그인</a></li>
						<li><a href="SignUp.jsp">회원가입</a></li>
					</ul>
				</li>
			</ul>
			<%
			} else { //로그인이 되어있을 때에만 보이도록 함.
			%>
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
			<%
				}
			%>		
		</div>
	</nav>
	<div class="container"> <%-- 게시글 표기되는 부분 --%>
		<div class="row"> <%-- 게시글을 행으로 나뉘는 표로 나눠서 표기. --%>
			<table class="table table-striped" style="text-align: center; border:1px solid #dddddd"><%-- 테이플 홀수짝수 색상구별 및 회색테두리--%>
				<thead><%-- table의 제목. 각 속성을 정의.  --%>
					<tr><%-- 3줄 차지 --%>
						<th colspan="3" style="background-color:#eeeeee; text-align: center">게시판 글 보기 양식</th>
					</tr>
				</thead>
				<tbody>
						<%-- 내용 표기 부분 --%>
					<tr>
						<td style="width: 20;">글 제목</td>
						<td colspan="2"><%= bbs.getBbsTitle().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>") %></td>
					</tr>
					<tr>
						<td>작성자</td>
						<td colspan="2"><%= bbs.getUserID() %></td>
					</tr>
					<tr>
						<td>작성일자</td>
						<td colspan="2"><%= bbs.getBbsDate().substring(0, 11)+ bbs.getBbsDate().substring(11, 13) + "시" + bbs.getBbsDate().substring(14, 16) + "분" %></td>
					</tr>
					<tr>
						<td style="text-align:center;">내용<br></td> <%-- 내용 중 특수문자, 공백들을 정상적으로 출력할 수 있도록 처리한다. --%>
						<%-- 글 내용 왼쪽정렬, 최소높이 200px --%>  <%-- &nbsp = 공백, &lt = <, &gt = >, <br> = \n --%>
						<td colspan="2" style="min-height:200px; text-align:left;"><%= bbs.getBbsContent().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>") %></td>
					</tr>
				</tbody>		
			</table>
			
			<a href="bbs.jsp" class="btn btn-primary">목록</a>
			
			<%//글의 작성자와 접속한 사람이 같은 경우에는 글을 수정, 삭제할 수 있도록 한다.
				if(userID != null && userID.equals(bbs.getUserID())){			
			%>
				<a href="update.jsp?bbsID=<%= bbsID%>" class="btn btn-primary">수정</a>
				<a onclick="return confirm(정말로 삭제하시겠습니까?)" href="deleteExecute.jsp?bbsID=<%= bbsID%>" class="btn btn-primary">삭제</a>
			<%  //이 윗줄에서 삭제를 누르면 정말 삭제하시겠습니까? 라고 한번 더 확인한다.
				} 
			%>

		</div>
	</div>
	
	
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
	
</body>
</html>