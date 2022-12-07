package bbs;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class BbsDB_Access {
	private Connection conn;					//DB�� ������ �� �ְ� ���ִ� ��ü
	private ResultSet result; 					//DB�� ������ ���� ��������� ���� ��ü
	
	public BbsDB_Access() {					//try-catch������ �Ͽ��� �ڵ����� DB�� ������ �� �ְ� �� �Ѵ�.
		try {
			String dbURL = "jdbc:mysql://localhost:3306/BBS";	//�������� DB�� �ּ�
			String dbAccount = "root";
			String dbPW = "alsydwjd121!";
			Class.forName("com.mysql.jdbc.Driver");				//mySQL�� ������ �� �ְ��ϴ� �Ű�ü ���̺귯��
			conn = DriverManager.getConnection(dbURL, dbAccount, dbPW); 	//������ ���̺귯���� �����ϰ� ���������� ����.
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
		return ""; //�����ͺ��̽� ����
	}
	
	public int getNext() {
		String SQL = "SELECT bbsID FROM BBS ORDER BY bbsID DESC";//������������ �����ؼ� ���� �ֱٿ� ���� ���� ������ �� �ֵ��� �Ѵ�.
		try {
			PreparedStatement pstat = conn.prepareStatement(SQL);
			result = pstat.executeQuery();
			if(result.next()) {
				return result.getInt(1) + 1;
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		return 1; //�����ͺ��̽� ����
	}
	
	public int write(String bbsTitle, String userID, String bbsContent) { //�� ���� DB�� �߰��ϴ� �Լ�.
		String SQL = "INSERT INTO BBS VALUES (?, ?, ?, ?, ?, ?)";//DB�� ������ �߰�
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
		return -1; //�����ͺ��̽� ����
	}
	
	public ArrayList<Bbs> getList(int pageNumber){ //�Խñ� ����Ʈ�� �������� �Լ�
		String SQL = "SELECT * FROM BBS WHERE bbsID < ? AND bbsAvailable = 1 ORDER BY bbsID DESC LIMIT 10";//bbs ID�� �������� �����͸� �������� bbsAvailable�� 1�ΰ͸� �����´�.
		ArrayList<Bbs> list = new ArrayList<Bbs>();
		try {
			PreparedStatement pstat = conn.prepareStatement(SQL);
			pstat.setInt(1, getNext() - (pageNumber - 1)*10);//Ư���� ������
			result = pstat.executeQuery();
			while(result.next()) { //������ ��������
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
		return list; //�����ͺ��̽� ����
	}
	
	public boolean nextPage(int pageNumber) {//Ư���� ������(11, 21, 31, .....)�� �����ϴ��� Ȯ���ϴ� �Լ�
		String SQL = "SELECT * FROM BBS WHERE bbsID < ? AND bbsAvailable = 1";//������������ �����ϴ��� Ȯ���ϱ� ���� ����
		
		try {
			PreparedStatement pstat = conn.prepareStatement(SQL);
			pstat.setInt(1, getNext() - (pageNumber - 1)*10);//Ư���� ������
			result = pstat.executeQuery();
			if(result.next()) {
				return true;
			}
			
		} catch(Exception e) {
			e.printStackTrace();
		}
		return false; //�����ͺ��̽� ����
	}
	
	public Bbs getBbs(int bbsID) {//�Խñ� ���� ���������� �Խñ� ������ �������� �Լ�
		String SQL = "SELECT * FROM BBS WHERE bbsID = ?";//DB���� Ư���� bbsID�� ���� �Խñ��� ��ȸ�Ѵ�.
		
		try {
			PreparedStatement pstat = conn.prepareStatement(SQL);
			pstat.setInt(1, bbsID);//Ư���� �Խñ�
			result = pstat.executeQuery();
			if(result.next()) {//������ �޾Ƽ� �ѱ�� �κ�.
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
		return null; //�����ͺ��̽� ����
	}
	
	public int update(int bbsID, String bbsTitle, String bbsContent) { //���� �Խñ��� �����̳� ������ �����ϴ� �Լ�
		String SQL = "UPDATE BBS SET bbsTitle = ?, bbsContent = ? WHERE bbsID = ?";//bbsID�� �Խñ��� ��ȸ�� �Ŀ� �ش� �Խñ� ���� ����.
		try {
			PreparedStatement pstat = conn.prepareStatement(SQL);
			pstat.setString(1, bbsTitle); //bbsID
			pstat.setString(2, bbsContent);
			pstat.setInt(3, bbsID); //bbsAvailable

			return pstat.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
		}
		return -1; //�����ͺ��̽� ����
	}
	
	public int delete(int bbsID) { //���� �Խñ��� �����̳� ������ �����ϴ� �Լ�
		String SQL = "UPDATE BBS SET bbsAvailable = 0 WHERE bbsID = ?";//bbsID�� �Խñ� ���͸� �� Available�� 0���� �����Ѵ�.
		try {
			PreparedStatement pstat = conn.prepareStatement(SQL);
			pstat.setInt(1, bbsID); //bbsID

			return pstat.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
		}
		return -1; //�����ͺ��̽� ����
	}
	
	
	
}
