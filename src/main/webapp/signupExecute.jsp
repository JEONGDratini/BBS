<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%--회원가입 시도--%>
<%@ page import="user.userDB_Access" %> <%-- 만들어놓은 자바 객체를 사용할 수 있도록 한다. --%>
<%@ page import="java.io.PrintWriter" %> <%-- 자바스크립트 문장을 쓰기 위해서 사용한다. --%>
<% request.setCharacterEncoding("UTF-8"); %> <%-- 넘어오는 데이터들을 UTF-8 형식으로 받아올 수 있도록 한다. --%>

<jsp:useBean id="user" class="user.User" scope="page" /> <%-- 이 페이지에서만 user패키지의 User클래스를 사용한다. --%>
<jsp:setProperty name="user" property="userID" /> <%-- 회원가입페이지의 userID를 받아서 사용자의 userID에 넣어준다.--%>
<jsp:setProperty name="user" property="userPassword" />
<jsp:setProperty name="user" property="userName" />
<jsp:setProperty name="user" property="userGender" />
<jsp:setProperty name="user" property="userEmail" />
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>게시판 웹사이트</title>
</head>
<body>
	<%
	//이미 로그인 되어있는 경우 필터링
		String userID = null;
		if(session.getAttribute("userID") != null) {//현재 세션에 있는 회원들의 세션 값을 넣는다.
			userID = (String)session.getAttribute("userID");
		}
		if(userID != null) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('이미 로그인이 되어있습니다.')");
			script.println("main.jsp");//경고 출력 후 이전페이지로 돌아감.
			script.println("</script>");
		}
		//입력되지 않은 것이 있을 때 필터링
		if (user.getUserID() == null || user.getUserPassword() == null || user.getUserName() == null 
			|| user.getUserGender() == null || user.getUserEmail() == null) {
			
			PrintWriter script = response.getWriter();
			
			script.println("<script>");
			script.println("alert('입력되지 않은 항목이 있습니다.')");
			script.println("history.back()");//경고 출력 후 이전페이지로 돌아감.
			script.println("</script>");
			
		} else {
			userDB_Access UserDAO = new userDB_Access(); //DB엑세스 객체 생성
			int result = UserDAO.signup(user);//회원가입 시도 후 결과를 저장.
			
			if(result == -1){ //데이터베이스 오류. userID는 primary key이므로 중복될 수 없기 때문이다. 즉, 같은 아이디를 생성하고자했을 때의 처리.
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('이미 존재하는 아이디입니다.')");
				script.println("history.back()");//경고 출력 후 이전페이지로 돌아감.
				script.println("</script>");
			}
			else { //정상일때.
				session.setAttribute("userID", user.getUserID());//현재 접속 중인 사용자를 관리하기 위한 세션부여
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("location.href = 'main.jsp'");
				script.println("</script>");
			}
			
		}
		

	%>
</body>
</html>