<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%--게시판 화면--%>
<%@ page import="java.io.PrintWriter" %> <%-- 자바스크립트 문장을 쓰기 위해서 사용한다. --%>
<%@ page import="bbs.BbsDB_Access" %> <%-- 게시판 DB에 접속하기 위해서 사용한다. 게시물 출력을 위해서 사용.--%>
<%@ page import="bbs.Bbs" %> <%-- 게시판 DB에 접속하기 위해서 사용한다. 게시물 출력을 위해서 사용.--%>
<%@ page import="java.util.ArrayList" %> <%-- 배열리스트 사용. 게시물 출력을 위해서 사용. --%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%--접속 기기 화면크기에 따라 달라지는 인터페이스--%>
<meta name="viewport" content="width=device-width", initial-scale="1">
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/my_own_custom.css">
<title>게시판 웹사이트</title>
<%-- 이 페이지에만 적용될 스타일 코드 --%>
<style type="text/css">
	a, a:hover {
		color:#000000;
		text-decoration: none;
	} 
</style>
</head>
<body>
	<%
	String userID = null;
	if(session.getAttribute("userID") != null) {//현재 세션에 있는 회원들의 세션 값을 저장한다.
		userID = (String)session.getAttribute("userID");
	}
	int pageNumber = 1; //기본 페이지
	if(request.getParameter("pageNumber") != null){ //받아온 페이지 번호를 int형에 맞게 변환 후 집어넣는다.
		pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
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
					<tr><%-- 1줄 --%>
						<th style="background-color:#eeeeee; text-align: center">번호</th>
						<th style="background-color:#eeeeee; text-align: center">제목</th>
						<th style="background-color:#eeeeee; text-align: center">작성자</th>
						<th style="background-color:#eeeeee; text-align: center">작성일</th>
					</tr>
				</thead>
				<tbody>
					<%
						BbsDB_Access bbsDAO = new BbsDB_Access();
						ArrayList<Bbs> list = bbsDAO.getList(pageNumber);//지금 페이지에서 나온 게시글 목록 표시
						for(int i = 0; i<list.size();i++) {
					%>
					<tr> 
						<td><%= list.get(i).getBbsID() %></td><%-- 게시글 출력 --%>
						<td><a href = "view.jsp?bbsID=<%= list.get(i).getBbsID() %>"><%= list.get(i).getBbsTitle() %></a></td> <%-- 해당 게시글 페이지로 이동하기. --%>
						<td><%= list.get(i).getUserID() %></td>
						<td><%= list.get(i).getBbsDate().substring(0, 11)+ list.get(i).getBbsDate().substring(11, 13) + "시" + list.get(i).getBbsDate().substring(14, 16) + "분" %></td>
					</tr>
					<%
						}
					%>
				</tbody>
			</table>
			<%
				if(pageNumber != 1) {
			%>
				<a href="bbs.jsp?pageNumber=<%=pageNumber - 1 %>" class="btn btn-success btn-arrow-left">이전페이지</a>
			<% 
				} 
				if(bbsDAO.nextPage(pageNumber + 1)){
			%>
				<a href="bbs.jsp?pageNumber=<%=pageNumber + 1 %>" class="btn btn-success btn-arrow-right">다음페이지</a>
			<%
				}
			%>
			<a href="write.jsp" class="btn btn-primary pull-right">글쓰기</a><%--버튼이 오른쪽에 고정되게끔 설정. --%>
		</div>
	</div>
	
	
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
	
</body>
</html>