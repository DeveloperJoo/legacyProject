<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/adm/step1/inc.jsp"%>
<%
	// 파라메터
	String procType = request.getParameter("procType");

	sysLog("# 처리유형 : " + procType);

	// 처리 후 이동할 경로
	String resUrl = "/adm/step1/devList.jsp";

	if(procType.equals("REMOVE")){
		int num = Integer.parseInt(request.getParameter("num"));

		Connection con = null;
		PreparedStatement pst = null;
		int result = 0;

		try{
			// 쿼리 만들기
			StringBuffer sb = new StringBuffer();
			sb.append("DELETE FROM ZTB_EDU_BOARD WHERE NUM=?");

			// db 데이터 가져오기
			con = getConnection();
			con.setAutoCommit(false);
			pst = con.prepareStatement(sb.toString());
			pst.setInt(1, num);
		
			sysLog("# 실행쿼리 : " + sb.toString());
		
			result = pst.executeUpdate();

			sysLog("# 처리건수 : " + result);

			con.commit();
			con.setAutoCommit(true);
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			if(pst != null) pst.close();
			if(con != null) con.close();
		}
	}else if(procType.equals("REMOVE_ALL")){
		String[] nums = request.getParameter("nums").split(",");

		Connection con = null;
		PreparedStatement pst = null;
		int result = 0;

		try{
			// 쿼리 만들기
			StringBuffer sb = new StringBuffer();
			sb.append("DELETE FROM ZTB_EDU_BOARD WHERE NUM=?");

			// db 데이터 가져오기
			con = getConnection();
			con.setAutoCommit(false);
			pst = con.prepareStatement(sb.toString());

			for(int i=0; i<nums.length; i++){
				pst.setInt(1, Integer.parseInt(nums[i]));

				sysLog("# 실행쿼리 : " + sb.toString());

				result += pst.executeUpdate();
			}

			sysLog("# 처리건수 : " + result);

			con.commit();
			con.setAutoCommit(true);
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			if(pst != null) pst.close();
			if(con != null) con.close();
		}
	}else if(procType.equals("CREATE") || procType.equals("MODIFY")){
		Integer num = null;
		String title = request.getParameter("title");
		String cont = request.getParameter("cont");
		String cateCd = request.getParameter("cateCd");
		String noteYn = request.getParameter("noteYn");

		// 등록 이라면
		if(procType.equals("CREATE")){
			Connection con = null;
			PreparedStatement pst = null;
			ResultSet rs = null;
			int result = 0;

			try{
				// 쿼리 만들기
				StringBuffer sb = new StringBuffer();
				sb.append("SELECT NVL(MAX(NUM), 0) + 1 AS NEXT_NUM FROM ZTB_EDU_BOARD");

				// db 데이터 가져오기
				con = getConnection();
				pst = con.prepareStatement(sb.toString());
				rs = pst.executeQuery();

				sysLog("# 실행쿼리 : " + sb.toString());

				while(rs.next()){
					num = rs.getInt("NEXT_NUM");
					break;
				}

				rs.close();
				pst.close();

				// 쿼리문 초기화
				sb.setLength(0);

				sb.append("INSERT INTO ZTB_EDU_BOARD(NUM,TITLE,CONT,CATE_CD,NOTE_YN,REG_DT,MOD_DT) VALUES(?,?,?,?,?,SYSDATE,SYSDATE)");

				con.setAutoCommit(false);
				pst = con.prepareStatement(sb.toString());
				int paramIdx = 1;
				pst.setInt(paramIdx++, num);
				pst.setString(paramIdx++, title);
				pst.setString(paramIdx++, cont);
				pst.setString(paramIdx++, cateCd);
				pst.setString(paramIdx++, noteYn);

				sysLog("# 실행쿼리 : " + sb.toString());
			
				result = pst.executeUpdate();

				sysLog("# 처리건수 : " + result);

				con.commit();
				con.setAutoCommit(true);
			}catch(Exception e){
				e.printStackTrace();
			}finally{
				if(pst != null) pst.close();
				if(con != null) con.close();
			}
		}else{
			num = Integer.parseInt(request.getParameter("num"));

			Connection con = null;
			PreparedStatement pst = null;
			int result = 0;

			try{
				// 쿼리 만들기
				StringBuffer sb = new StringBuffer();
				sb.append("UPDATE ZTB_EDU_BOARD SET TITLE=?,CONT=?,CATE_CD=?,NOTE_YN=?,MOD_DT=SYSDATE WHERE NUM=?");

				// db 데이터 가져오기
				con = getConnection();
				con.setAutoCommit(false);
				pst = con.prepareStatement(sb.toString());
				int paramIdx = 1;
				pst.setString(paramIdx++, title);
				pst.setString(paramIdx++, cont);
				pst.setString(paramIdx++, cateCd);
				pst.setString(paramIdx++, noteYn);
				pst.setInt(paramIdx++, num);
			
				sysLog("# 실행쿼리 : " + sb.toString());
			
				result = pst.executeUpdate();

				sysLog("# 처리건수 : " + result);

				con.commit();
				con.setAutoCommit(true);
			}catch(Exception e){
				e.printStackTrace();
			}finally{
				if(pst != null) pst.close();
				if(con != null) con.close();
			}
		}

		resUrl = "/adm/step1/devDetail.jsp?num=" + num;
	}

	response.sendRedirect(resUrl);
%>