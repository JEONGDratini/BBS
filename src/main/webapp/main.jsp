<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%--메인 화면--%>
<%@ page import="java.io.PrintWriter" %> <%-- 자바스크립트 문장을 쓰기 위해서 사용한다. --%>
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
				<li class="active"><a href="main.jsp">메인</a></li> <%-- active 클래스는 현재 접속되어있는 페이지가 main이라고 알려준다. --%>
				<li><a href="bbs.jsp">게시판</a></li>
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
	
	<div class="container">
		<div class="jumbotron"><%-- jumbotron = 부트스트랩에서 제공하는 기능 --%>
			<div class="container">
				<h1>사이트 소개</h1>
				<p>jsp-DB-java-bootstrap 공부 겸 만들어본 jsp게시판 웹사이트입니다. 아직 손 볼 부분이 굉장히 많습니다. 디자인템플릿 -> 부트스트랩</p>
				<p><a class="btn btn-primary btn-pull" href="#" role="button">더보기</a></p>
			</div>		
		</div>
	</div>
	
	<div class="container">
		<div id="myCarousel" class="carousel" data-ride="carousel">
			<ol class="carousel-indicators"> <%-- 이미지 띄우는 곳 양식. --%>
				<li data-target="#myCarousel" data-slide-to="0" class="active"></li>
				<li data-target="#myCarousel" data-slide-to="1"></li>
				<li data-target="#myCarousel" data-slide-to="2"></li>
			</ol>
			<div class="carousel-inner"> <%-- 실제로 이미지를 띄우는 곳 --%>
	 			<div class="item active">
					<img src="images/풋살창현좌.jpg">
				</div>
	
				<div class="item">
					<img src="images/고요한오케스트라.jpg">
				</div>
				<div class="item">
					<img src="images/사육제에요.jpg">
				</div>
			</div>
			<a class="left carousel-control" href="#myCarousel" data-slide="prev"> <%-- 이전 버튼 만들기 --%>
				<span class ="glyphicon glyphicon-shevron-left"></span>
			</a>
			<a class="left carousel-control" href="#myCarousel" data-slide="next"> <%-- 다음 버튼 만들기 --%>
				<span class ="glyphicon glyphicon-shevron-right"></span>
			</a>
		</div>
	</div>
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
	
</body>
</html>