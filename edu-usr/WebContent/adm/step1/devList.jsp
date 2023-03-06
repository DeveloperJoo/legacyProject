<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/adm/step1/inc.jsp"%>
<%
	// 파라메터
	String srchTitle = request.getParameter("title");
	String srchCateCd = request.getParameter("cateCd");
	String srchNoteYn = request.getParameter("noteYn");

	if(srchTitle == null) srchTitle = "";
	if(srchCateCd == null) srchCateCd = "";
	if(srchNoteYn == null) srchNoteYn = "";
%>
<!DOCTYPE html>
<html>
	<head>
		<title>목록</title>
		<script type="text/javascript">
			// 초기화
			window.onload = function(){
				// 제목/내용 이벤트
				document.getElementById("srchVal").addEventListener("keydown", function(event){
					// 엔터키 입력시 조회 실행
					if(event.keyCode == 13) {
						srch();
					}
				}, false);
			};

			// 조회
			function srch(){
				document.getElementById("title").value = document.getElementById("srchVal").value;
				document.getElementById("cateCd").value = document.getElementById("srchCateCd").value;
				document.getElementById("noteYn").value = (document.getElementById("srchNoteYn").checked ? "Y" : "N");

				document.getElementById("devForm").setAttribute("action", "/adm/step1/devList.jsp");
				document.getElementById("devForm").submit();
			}

			// 선택 삭제 처리
			function procRemoveAll(){
				var nums = "";

				document.querySelectorAll("#dataTableBody input[type='checkbox']:checked").forEach(function(item){
					if(nums != ""){
						nums += ",";
					}
					// closest = 상위태그 찾는 함수
					nums += item.closest("tr[num]").getAttribute("num");
				});

				if(nums == ""){
					alert("삭제할 데이터를 선택 해 주세요.");
					return;
				}

				if(confirm("선택 데이터를 삭제 하시겠습니까?")){
					document.getElementById("nums").value = nums;
					document.getElementById("procType").value = "REMOVE_ALL";

					document.getElementById("devForm").setAttribute("action", "/adm/step1/devProc.jsp");
					document.getElementById("devForm").submit();	
				}
			}

			// 전체 체크
			function setAllCheck(flag){
				document.querySelectorAll("#dataTableBody input[type='checkbox']").forEach(function(item){
					item.checked = flag;
				});
			}

			// 등록 페이지 이동
			function goSave(){
				location.href = "/adm/step1/devSave.jsp";
			}

			// 상세 페이지로 이동
			function goDetail(num){
				location.href = "/adm/step1/devDetail.jsp?num=" + num;
			}
		</script>
	</head>
	<body>
		<form id="devForm" method="POST">
			<input type="hidden" id="procType" name="procType" />
			<input type="hidden" id="num" name="num" />
			<input type="hidden" id="nums" name="nums" />
			<input type="hidden" id="title" name="title" />
			<input type="hidden" id="cateCd" name="cateCd" />
			<input type="hidden" id="noteYn" name="noteYn" />
		</form>
		<div>
			<b>조회조건</b>
			<span style="float:right;"><button onclick="procRemoveAll();">선택 삭제</button></span>
			<span style="float:right;">&nbsp;</span>
			<span style="float:right;"><button onclick="goSave();">등록 페이지</button></span>
			<span style="float:right;">&nbsp;</span>
			<span style="float:right;"><button onclick="srch();">조회</button></span>
		</div>
		<table border="1" style="width:100%;">
			<col width="100"/>
			<col width="*"/>
			<col width="100"/>
			<col width="150"/>
			<col width="100"/>
			<col width="150"/>
			<tbody>
				<tr>
					<th>제목/내용</th>
					<td>
						<input type="text" id="srchVal" style="width:99%;" value="<%=srchTitle%>"/>
					</td>
					<th>카테고리</th>
					<td align="center">
						<select id="srchCateCd" style="width:100px;">
							<option value="">전체</option>
<%
	Map<String, String> cateCdMap = getCateCdMap();

	for(Map.Entry<String, String> elem : cateCdMap.entrySet()){
		if(srchCateCd.equals(elem.getKey())){
			out.println("<option value='" + elem.getKey() + "' selected='selected'>" + elem.getValue() + "</option>");
		}else{
			out.println("<option value='" + elem.getKey() + "'>" + elem.getValue() + "</option>");
		}
	}
%>
						</select>
					</td>
					<th>공지여부</th>
					<td align="center">
						<input type="checkbox" id="srchNoteYn" <%if(srchNoteYn.equals("Y")){%>checked="checked"<%}%>/>
					</td>
				</tr>
			</tbody>
		</table>

		<div style="height:20px;"></div>
		<div><b>조회목록</b></div>
		<table border="1" style="width:100%;">
			<col width="50"/>
			<col width="100"/>
			<col width="*"/>
			<col width="100"/>
			<col width="100"/>
			<col width="200"/>
			<col width="200"/>
			<thead>
				<tr>
					<th><input type="checkbox" onclick="setAllCheck(this.checked);"/></th>
					<th>순번</th>
					<th>제목</th>
					<th>카테고리</th>
					<th>공지여부</th>
					<th>등록일</th>
					<th>수정일</th>
				</tr>
			</thead>
			<tbody id="dataTableBody">
<%
	Connection con = null;
	PreparedStatement pst = null;
	ResultSet rs = null;

	try{
		// 데이트 포맷
		SimpleDateFormat dtFormat = new SimpleDateFormat("yyyy-MM-dd hh:mm");

		// 쿼리 만들기
		StringBuffer sb = new StringBuffer();
		sb.append("SELECT NUM,TITLE,CATE_CD,NOTE_YN,REG_DT,MOD_DT FROM ZTB_EDU_BOARD WHERE 1=1");

		if(!srchTitle.equals("")){
			sb.append(" AND (TITLE LIKE '%' || ? || '%' OR CONT LIKE '%' || ? || '%')");
		}
		
		if(!srchCateCd.equals("")){
			sb.append(" AND CATE_CD = ?");
		}

		if(srchNoteYn.equals("Y")){
			sb.append(" AND NOTE_YN = 'Y'");
		}

		sb.append(" ORDER BY NUM DESC");

		// db 데이터 가져오기
		con = getConnection();
		pst = con.prepareStatement(sb.toString());
		int paramIdx = 1;

		if(!srchTitle.equals("")){
			pst.setString(paramIdx++, srchTitle);
			pst.setString(paramIdx++, srchTitle);
		}

		if(!srchCateCd.equals("")){
			pst.setString(paramIdx++, srchCateCd);
		}

		sysLog("# 실행쿼리 : " + sb.toString());

		rs = pst.executeQuery();

		while(rs.next()){
			out.println("<tr num='" + rs.getObject("NUM") + "'>");
			out.println("	<td align='center'><input type='checkbox'/></td>");
			out.println("	<td align='center'>" + rs.getObject("NUM") + "</td>");
			out.println("	<td><a href='javascript:goDetail(" + rs.getObject("NUM") + ");'>" + rs.getObject("TITLE") + "</a></td>");
			out.println("	<td align='center'>" + getCateCdNm(rs.getString("CATE_CD")) + "</td>");
			out.println("	<td align='center'>" + rs.getObject("NOTE_YN") + "</td>");
			out.println("	<td align='center'>" + dtFormat.format(rs.getDate("REG_DT")) + "</td>");
			out.println("	<td align='center'>" + dtFormat.format(rs.getDate("MOD_DT")) + "</td>");
			out.println("</tr>");
		}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		if(rs != null) rs.close();
		if(pst != null) pst.close();
		if(con != null) con.close();
	}
%>
			</tbody>
		</table>
	</body>
</html>