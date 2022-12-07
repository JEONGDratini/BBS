package bbs;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class BbsDB_Access {
	private Connection conn;					//DB에 접근할 수 있게 해주는 객체
	private ResultSet result; 					//DB에 쿼리를 넣은 결과정보를 담을 객체
	
	public BbsDB_Access() {					//try-catch문으로 하여금 자동으로 DB에 접속할 수 있게 끔 한다.
		try {
			String dbURL = "jdbc:mysql://localhost:3306/BBS";	//내가만든 DB의 주소
			String dbAccount = "root";
			String dbPW = "alsydwjd121!";
			Class.forName("com.mysql.jdbc.Driver");				//mySQL에 접속할 수 있게하는 매개체 라이브러리
			conn = DriverManager.getConnection(dbURL, dbAccount, dbPW); 	//가져온 라이브러리로 접속하고 접속정보를 저장.
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	public String getDate() {
		String SQL = "SELECT NOW()";
		try {
			PreparedStatement pstat = conn.prepareStatement(SQL);
			result = pstat.executeQuery();
			if(result.next()) {
				return result.getString(1);
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		return ""; //데이터베이스 오류
	}
	
	public int getNext() {
		String SQL = "SELECT bbsID FROM BBS ORDER BY bbsID DESC";//내림차순으로 정렬해서 가장 최근에 쓰인 글을 가져올 수 있도록 한다.
		try {
			PreparedStatement pstat = conn.prepareStatement(SQL);
			result = pstat.executeQuery();
			if(result.next()) {
				return result.getInt(1) + 1;
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		return 1; //데이터베이스 오류
	}
	
	public int write(String bbsTitle, String userID, String bbsContent) { //쓴 글을 DB에 추가하는 함수.
		String SQL = "INSERT INTO BBS VALUES (?, ?, ?, ?, ?, ?)";//DB에 데이터 추가
		try {
			PreparedStatement pstat = conn.prepareStatement(SQL);
			pstat.setInt(1, getNext()); //bbsID
			pstat.setString(2, bbsTitle);
			pstat.setString(3, userID);
			pstat.setString(4, getDate());
			pstat.setString(5, bbsContent);
			pstat.setInt(6, 1); //bbsAvailable

			return pstat.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
		}
		return -1; //데이터베이스 오류
	}
	
	public ArrayList<Bbs> getList(int pageNumber){ //게시글 리스트를 가져오는 함수
		String SQL = "SELECT * FROM BBS WHERE bbsID < ? AND bbsAvailable = 1 ORDER BY bbsID DESC LIMIT 10";//bbs ID를 기준으로 데이터를 가져오되 bbsAvailable이 1인것만 가져온다.
		ArrayList<Bbs> list = new ArrayList<Bbs>();
		try {
			PreparedStatement pstat = conn.prepareStatement(SQL);
			pstat.setInt(1, getNext() - (pageNumber - 1)*10);//특정한 페이지
			result = pstat.executeQuery();
			while(result.next()) { //데이터 가져오기
				Bbs bbs = new Bbs();
				bbs.setBbsID(result.getInt(1));
				bbs.setBbsTitle(result.getString(2));
				bbs.setUserID(result.getString(3));
				bbs.setBbsDate(result.getString(4));
				bbs.setBbsContent(result.getString(5));
				bbs.setBbsAvailable(result.getInt(6));
				list.add(bbs);
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		return list; //데이터베이스 오류
	}
	
	public boolean nextPage(int pageNumber) {//특정한 페이지(11, 21, 31, .....)가 존재하는지 확인하는 함수
		String SQL = "SELECT * FROM BBS WHERE bbsID < ? AND bbsAvailable = 1";//다음페이지가 존재하는지 확인하기 위한 쿼리
		
		try {
			PreparedStatement pstat = conn.prepareStatement(SQL);
			pstat.setInt(1, getNext() - (pageNumber - 1)*10);//특정한 페이지
			result = pstat.executeQuery();
			if(result.next()) {
				return true;
			}
			
		} catch(Exception e) {
			e.printStackTrace();
		}
		return false; //데이터베이스 오류
	}
	
	public Bbs getBbs(int bbsID) {//게시글 보기 페이지에서 게시글 내용을 가져오는 함수
		String SQL = "SELECT * FROM BBS WHERE bbsID = ?";//DB에서 특정한 bbsID를 가진 게시글을 조회한다.
		
		try {
			PreparedStatement pstat = conn.prepareStatement(SQL);
			pstat.setInt(1, bbsID);//특정한 게시글
			result = pstat.executeQuery();
			if(result.next()) {//내용을 받아서 넘기는 부분.
				Bbs bbs = new Bbs();
				bbs.setBbsID(result.getInt(1));
				bbs.setBbsTitle(result.getString(2));
				bbs.setUserID(result.getString(3));
				bbs.setBbsDate(result.getString(4));
				bbs.setBbsContent(result.getString(5));
				bbs.setBbsAvailable(result.getInt(6));
				return bbs;
			}
			
		} catch(Exception e) {
			e.printStackTrace();
		}
		return null; //데이터베이스 오류
	}
	
	public int update(int bbsID, String bbsTitle, String bbsContent) { //기존 게시글의 내용이나 제목을 수정하는 함수
		String SQL = "UPDATE BBS SET bbsTitle = ?, bbsContent = ? WHERE bbsID = ?";//bbsID로 게시글을 조회한 후에 해당 게시글 내용 수정.
		try {
			PreparedStatement pstat = conn.prepareStatement(SQL);
			pstat.setString(1, bbsTitle); //bbsID
			pstat.setString(2, bbsContent);
			pstat.setInt(3, bbsID); //bbsAvailable

			return pstat.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
		}
		return -1; //데이터베이스 오류
	}
	
	public int delete(int bbsID) { //기존 게시글의 내용이나 제목을 수정하는 함수
		String SQL = "UPDATE BBS SET bbsAvailable = 0 WHERE bbsID = ?";//bbsID로 게시글 필터링 후 Available을 0으로 설정한다.
		try {
			PreparedStatement pstat = conn.prepareStatement(SQL);
			pstat.setInt(1, bbsID); //bbsID

			return pstat.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
		}
		return -1; //데이터베이스 오류
	}
	
	
	
}
