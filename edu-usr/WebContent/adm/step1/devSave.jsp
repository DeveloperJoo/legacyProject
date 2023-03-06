<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/adm/step1/inc.jsp"%>
<%
	//결과 데이터
	Integer num = null;
	String title = null;
	String cont = null;
	String cateCd = null;
	String noteYn = null;

	if(request.getParameter("num") != null){
		// 파라메터
		int paramNum = Integer.parseInt(request.getParameter("num"));

		Connection con = null;
		PreparedStatement pst = null;
		ResultSet rs = null;

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
	}
%>
<!DOCTYPE html>
<html>
	<head>
		<title>등록/수정</title>
		<script type="text/javascript">
			// 저장
			function procSave(){
				if(document.getElementById("detailTitle").value == ""){
					alert("제목을 입력 해 주세요.");
					document.getElementById("detailTitle").focus();
					return;
				}

				var procType = "CREATE";
				var msg = "등록";

				// 수정 이라면
				if(document.getElementById("num").value != ""){
					procType = "MODIFY";
					msg = "수정";
				}

				if(confirm(msg + " 하시겠습니까?")){
					document.getElementById("title").value = document.getElementById("detailTitle").value;
					document.getElementById("cont").value = document.getElementById("detailCont").value;
					document.getElementById("cateCd").value = document.getElementById("detailCateCd").value;
					document.getElementById("noteYn").value = (document.getElementById("detailNoteYn").checked ? "Y" : "N");
					document.getElementById("procType").value = procType;
	
					document.getElementById("devForm").setAttribute("action", "/adm/step1/devProc.jsp");
					document.getElementById("devForm").submit();
				}
			}

			// 뒤로가기
			function goBack(){
				history.back();
			}

			// 목록 페이지 이동
			function goList(){
				location.href = "/adm/step1/devList.jsp";
			}
		</script>
	</head>
	<body>
		<form id="devForm" method="POST">
			<input type="hidden" id="procType" name="procType"/>
			<input type="hidden" id="num" name="num" value="<%=(num != null ? num : "")%>"/>
			<input type="hidden" id="title" name="title" />
			<input type="hidden" id="cont" name="cont" />
			<input type="hidden" id="cateCd" name="cateCd" />
			<input type="hidden" id="noteYn" name="noteYn" />
		</form>
		<div>
			<b><%=(num == null ? "등록" : "수정")%> 페이지</b>
			<span style="float:right;"><button onclick="procSave();">저장</button></span>
			<span style="float:right;">&nbsp;</span>
			<span style="float:right;"><button onclick="goBack();">뒤로가기</button></span>
			<span style="float:right;">&nbsp;</span>
			<span style="float:right;"><button onclick="goList();">목록 페이지</button></span>
		</div>
		<table border="1" style="width:100%;">
			<col width="100"/>
			<col width="*"/>
			<tbody>
				<tr>
					<th>제목</th>
					<td>
						<input type="text" id="detailTitle" style="width:99%;" value="<%=(num != null ? title : "")%>"/>
					</td>
				</tr>
				<tr>
					<th>카테고리</th>
					<td align="left">
						<select id="detailCateCd" style="width:100px;">
<%
	Map<String, String> cateCdMap = getCateCdMap();

	for(Map.Entry<String, String> elem : cateCdMap.entrySet()){
		if(num != null && cateCd.equals(elem.getKey())){
			out.println("<option value='" + elem.getKey() + "' selected='selected'>" + elem.getValue() + "</option>");
		}else{
			out.println("<option value='" + elem.getKey() + "'>" + elem.getValue() + "</option>");
		}
	}
%>
						</select>
					</td>
				</tr>
				<tr>
					<th>공지여부</th>
					<td align="left">
						<input type="checkbox" id="detailNoteYn" <%if(num != null && noteYn.equals("Y")){%>checked="checked"<%}%>/>
					</td>
				</tr>
				<tr>
					<th>내용</th>
					<td>
						<textarea id="detailCont" style="width:99%; height:300px;"><%=(num != null ? cont : "")%></textarea>
					</td>
				</tr>
			</tbody>
		</table>
	</body>
</html>