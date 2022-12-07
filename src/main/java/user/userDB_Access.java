package user;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
//================================DB에 접근할 때 쓰는 메서드들을 모아놓는 클래스==============================
public class userDB_Access {
	
	private Connection conn;					//DB에 접근할 수 있게 해주는 객체
	private PreparedStatement pstat; 			//DB에 넣을 쿼리내용을 담을 객체
	private ResultSet result; 					//DB에 쿼리를 넣은 결과정보를 담을 객체
	
	public userDB_Access() {					//try-catch문으로 하여금 자동으로 DB에 접속할 수 있게 끔 한다.
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
	
	public int login(String userID, String userPassword) {	//로그인 시도해주는 함수.
		//user 테이블에서 해당 사용자의 비밀번호를 가져올 수 있도록 하는 명령어.
		//미리 코드에서 준비된 문구만을 사용하도록 함으로써 SQL Injection같은 해킹기법을 방어할 수 있다.
		String SQL = "SELECT userPassword FROM USER WHERE userID = ?";//쿼리 준비
		try {
			pstat = conn.prepareStatement(SQL);  	//준비된 쿼리 넣기
			pstat.setString(1, userID);				// SQL문자열의 ? 대신 들어갈 문구를 설정해준다.
			result = pstat.executeQuery(); 			//result에 DB 쿼리 조회를 한 결과를 집어넣는다.
			
			if(result.next()) {						//결과가 존재할 때 실행
				if(result.getString(1).equals(userPassword)) {		//result의 내용이 userPassword와 같을 때 실행
					return 1; //로그인 성공.
				}
				return 0; //비밀번호가 틀림.
			}
			return -1;		//아이디가 존재하지 않음.
				
		} catch (Exception e) {
			e.printStackTrace();
		}	
		return -2; 			//데이터베이스 오류
	}
	
	public int signup(User user) {
		String SQL = "INSERT INTO USER VALUES (?, ?, ?, ?, ?)";	//user테이블에 새 값을 집어넣는다.
		try {
			pstat = conn.prepareStatement(SQL);
			pstat.setString(1, user.getUserID());
			pstat.setString(2, user.getUserPassword());
			pstat.setString(3, user.getUserName());
			pstat.setString(4, user.getUserGender());
			pstat.setString(5, user.getUserEmail());
			return pstat.executeUpdate();			//0이상의 숫자 반환
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;			//데이터베이스 오류
	}
}
