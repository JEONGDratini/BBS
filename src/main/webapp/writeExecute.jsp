<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%--회원가입 시도--%>
<%@ page import="bbs.BbsDB_Access" %> <%-- 만들어놓은 자바 객체를 사용할 수 있도록 한다. --%>
<%@ page import="java.io.PrintWriter" %> <%-- 자바스크립트 문장을 쓰기 위해서 사용한다. --%>
<% request.setCharacterEncoding("UTF-8"); %> <%-- 넘어오는 데이터들을 UTF-8 형식으로 받아올 수 있도록 한다. --%>

<jsp:useBean id="bbs" class="bbs.Bbs" scope="page" /> <%-- 이 페이지에서만 bbs패키지의 Bbs클래스를 사용한다. --%>
<jsp:setProperty name="bbs" property="bbsTitle" /> <%-- 회원가입페이지의 bbsTitle를 받아서 사용자의 DB에 넣어준다.--%>
<jsp:setProperty name="bbs" property="bbsContent" />

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>게시판 웹사이트</title>
</head>
<body>
	<%
		String userID = null;
		if(session.getAttribute("userID") != null) {//현재 세션에 있는 회원들의 세션 값을 넣는다.
			userID = (String)session.getAttribute("userID");
		}
		if(userID == null) {//로그인 되지 않았을 때 경우 필터링
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인을 하세요')");
			script.println("location.href = 'main.jsp'");//경고 출력 후 이전페이지로 돌아감.
			script.println("</script>");
		}
		else{
			if (bbs.getBbsTitle() == null || bbs.getBbsContent() == null) {//입력되지 않은 것이 있을 때 필터링
				
				PrintWriter script = response.getWriter();
				
				script.println("<script>");
				script.println("alert('입력되지 않은 항목이 있습니다.')");
				script.println("history.back()");//경고 출력 후 이전페이지로 돌아감.
				script.println("</script>");
				
			} else {
				BbsDB_Access BbsDAO = new BbsDB_Access(); //DB엑세스 객체 생성
				int result = BbsDAO.write(bbs.getBbsTitle(), userID, bbs.getBbsContent());//글 쓰기 시도 후 결과를 저장.
				
				if(result == -1){ 
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('글쓰기 실패했습니다.')");
					script.println("history.back()");//경고 출력 후 이전페이지로 돌아감.
					script.println("</script>");
				}
				else { //정상일때.
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("location.href = 'bbs.jsp'");
					script.println("</script>");
				}
				
			}
		}
		

	%>
</body>
</html>