<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%--회원가입 시도--%>
<%@ page import="bbs.BbsDB_Access" %> <%-- 만들어놓은 자바 객체를 사용할 수 있도록 한다. --%>
<%@ page import="bbs.Bbs" %>
<%@ page import="java.io.PrintWriter" %> <%-- 자바스크립트 문장을 쓰기 위해서 사용한다. --%>
<% request.setCharacterEncoding("UTF-8"); %> <%-- 넘어오는 데이터들을 UTF-8 형식으로 받아올 수 있도록 한다. --%>
<%-- 이번엔 자바 빈즈를 사용하지 않는다. --%>

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
		else{
			if (request.getParameter("bbsTitle") == null || request.getParameter("bbsContent") == null
					|| request.getParameter("bbsTitle").equals("") || request.getParameter("bbsContent").equals("")) {//입력되지 않은 것이 있을 때 필터링
				
				PrintWriter script = response.getWriter();
				
				script.println("<script>");
				script.println("alert('입력되지 않은 항목이 있습니다.')");
				script.println("history.back()");//경고 출력 후 이전페이지로 돌아감.
				script.println("</script>");
				
			} else {
				BbsDB_Access BbsDAO = new BbsDB_Access(); //DB엑세스 객체 생성
				int result = BbsDAO.update(bbsID, request.getParameter("bbsTitle"), request.getParameter("bbsContent"));//글 수정 시도 후 결과를 저장.
											//이번엔 자바 빈즈를 쓰지 않았기 때문에 bbsTitle과 bbsContent를 파라미터 함수를 이용해 받아온다.
				if(result == -1){ 
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('수정에 실패했습니다.')");
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