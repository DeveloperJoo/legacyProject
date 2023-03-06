<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.lang.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.sql.*" %>
<%!
	// 커넥션 가져오기
	public Connection getConnection(){
		String url = "jdbc:oracle:thin:@119.192.172.120:1521/ORCL";
		String id = "EDU";
		String pw = "EDUPASS1234";

		Connection conn = null;

		try{
			Class.forName("oracle.jdbc.driver.OracleDriver");
			conn = DriverManager.getConnection(url, id, pw);
		}catch(Exception e){
			e.printStackTrace();
		}

		return conn;
	}

	// 카테고리 코드 목록 가져오기
	public Map<String, String> getCateCdMap(){
		Map<String, String> cateCdMap = new HashMap<String, String>();
		cateCdMap.put("1", "업무");
		cateCdMap.put("2", "일정");
		cateCdMap.put("3", "일반");

		return cateCdMap;
	}

	// 카테고리 코드명 가져오기
	public String getCateCdNm(String cateCd){
		return getCateCdMap().get(cateCd);
	}

	// 시스템 로그
	public void sysLog(Object obj){
		System.out.println(obj.toString());
	}
%>
<%
	request.setCharacterEncoding("utf-8");
%>