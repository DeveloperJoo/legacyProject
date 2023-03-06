<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/adm/step1/inc.jsp"%>
<%
	// 파라메터
	int paramNum = Integer.parseInt(request.getParameter("num"));

	// 결과 데이터
	Integer num = null;
	String title = null;
	String cont = null;
	String cateCd = null;
	String noteYn = null;
	java.util.Date regDt = null;
	java.util.Date modDt = null;

	Connection con = null;
	PreparedStatement pst = null;
	ResultSet rs = null;

	// 데이트 포맷
	SimpleDateFormat dtFormat = new SimpleDateFormat("yyyy-MM-dd hh:mm");

	try{
		// 쿼리 만들기
		StringBuffer sb = new StringBuffer();
		sb.append("SELECT NUM,TITLE,CONT,CATE_CD,NOTE_YN,REG_DT,MOD_DT FROM ZTB_EDU_BOARD WHERE NUM=?");

		// db 데이터 가져오기
		con = getConnection();
		pst = con.prepareStatement(sb.toString());
		pst.setInt(1, paramNum);
	
		sysLog("# 실행쿼리 : " + sb.toString());
	
		rs = pst.executeQuery();
	
		while(rs.next()){
			num = rs.getInt("NUM");
			title = rs.getString("TITLE");
			cont = rs.getString("CONT");
			cateCd = rs.getString("CATE_CD");
			noteYn = rs.getString("NOTE_YN");
			regDt = rs.getDate("REG_DT");
			modDt = rs.getDate("MOD_DT");

			if(title == null) title = "";
			if(cont == null) cont = "";
			if(cateCd == null) cateCd = "";
			if(noteYn == null) noteYn = "";

			break;
		}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		if(rs != null) rs.close();
		if(pst != null) pst.close();
		if(con != null) con.close();
	}
%>
<!DOCTYPE html>
<html>
	<head>
		<title>상세</title>
		<script type="text/javascript">
			// 삭제 처리
			function procRemove(){
				if(confirm("삭제 하시겠습니까?")){
					document.getElementById("procType").value = "REMOVE";
	
					document.getElementById("devForm").setAttribute("action", "/adm/step1/devProc.jsp");
					document.getElementById("devForm").submit();
				}
			}

			// 수정 페이지 이동
			function goSave(){
				var num = document.getElementById("num").value;

				location.href = "/adm/step1/devSave.jsp?num=" + num;
			}

			// 목록 페이지 이동
			function goList(){
				location.href = "/adm/step1/devList.jsp";
			}
		</script>
	</head>
	<body>
		<form id="devForm" method="POST">
			<input type="hidden" id="procType" name="procType" />
			<input type="hidden" id="num" name="num" value="<%=num%>" />
		</form>
		<div>
			<b>상세정보</b>
			<span style="float:right;"><button onclick="procRemove();">삭제</button></span>
			<span style="float:right;">&nbsp;</span>
			<span style="float:right;"><button onclick="goSave();">수정 페이지</button></span>
			<span style="float:right;">&nbsp;</span>
			<span style="float:right;"><button onclick="goList();">목록 페이지</button></span>
		</div>
		<table border="1" style="width:100%;">
			<col width="100"/>
			<col width="*"/>
			<col width="100"/>
			<col width="*"/>
			<tbody>
				<tr>
					<th>제목</th>
					<td colspan="3"><%=title%></td>
				</tr>
				<tr>
					<th>카테고리</th>
					<td align="center"><%=getCateCdNm(cateCd)%></td>
					<th>공지여부</th>
					<td align="center"><%=noteYn%></td>
				</tr>
				<tr>
					<th>등록일</th>
					<td align="center"><%=dtFormat.format(regDt)%></td>
					<th>수정일</th>
					<td align="center"><%=dtFormat.format(modDt)%></td>
				</tr>
				<tr>
					<th>내용</th>
					<td colspan="3" valign="top" style="white-space:pre;"><%=cont%></td>
				</tr>
			</tbody>
		</table>
	</body>
</html>