package adm.util;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

/**
 * 관리자 개발 유틸 클래스
 */
public class AdmDevUtil {

	/**
	 * 커넥션 가져오기
	 * @return	Connection
	 */
	public static Connection getConnection(){
		String jndiNm = "java:/comp/env/jdbc/orcl";

		Connection conn = null;

		try{
			Context initCtx = new InitialContext();
			DataSource ds = (DataSource) initCtx.lookup(jndiNm);
			conn = ds.getConnection();
		}catch(Exception e){
			e.printStackTrace();
		}

		return conn;
	}

	/**
	 * 커넥션 닫기
	 * @param 	pst
	 */
	public static void closeConnection(Connection con) {
		closeConnection(con, null, null);
	}

	/**
	 * 커넥션 닫기
	 * @param 	pst
	 */
	public static void closeConnection(PreparedStatement pst) {
		closeConnection(null, pst, null);
	}

	/**
	 * 커넥션 닫기
	 * @param 	con
	 * @param 	pst
	 */
	public static void closeConnection(Connection con, PreparedStatement pst) {
		closeConnection(con, pst, null);
	}

	/**
	 * 커넥션 닫기
	 * @param 	con
	 * @param 	pst
	 * @param 	rs
	 */
	public static void closeConnection(Connection con, PreparedStatement pst, ResultSet rs) {
		try{
			if(rs != null) rs.close();
			if(pst != null) pst.close();
			if(con != null) con.close();
		}catch(Exception e){
			e.printStackTrace();
		}
	}

	/**
	 * 카테고리 코드 맵 가져오기
	 * @return	Map<String, String>
	 */
	public static Map<String, String> getCateCdMap(){
		Map<String, String> cateCdMap = new HashMap<String, String>();
		cateCdMap.put("1", "업무");
		cateCdMap.put("2", "일정");
		cateCdMap.put("3", "일반");

		return cateCdMap;
	}

	/**
	 * 카테고리 코드명 가져오기
	 * @param 	cateCd
	 * @return	String
	 */
	public static String getCateCdNm(String cateCd){
		return getCateCdMap().get(cateCd);
	}

	/**
	 * 데이트 포맷 문자열 가져오기
	 * @param 	date
	 * @return	String
	 */
	public static String getDateFormat(Date date) {
		return getDateFormat(date, "yyyy-MM-dd hh:mm");
	}

	/**
	 * 데이트 포맷 문자열 가져오기
	 * @param 	date
	 * @param 	format
	 * @return	String
	 */
	public static String getDateFormat(Date date, String format) {
		SimpleDateFormat dtFormat = new SimpleDateFormat(format);

		return dtFormat.format(date);
	}

	/**
	 * 시스템 로그 출력
	 * @param 	obj
	 */
	public static void sysLog(Object obj){
		System.out.println(obj.toString());
	}
}
