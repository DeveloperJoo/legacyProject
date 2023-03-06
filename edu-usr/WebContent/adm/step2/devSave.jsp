<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/adm/step2/inc.jsp"%>
<%
	AdmDevVo data = null;

	if(request.getParameter("num") != null){
		//검색 객체 설정
		AdmDevVo srchAdmDevVo = new AdmDevVo();
		srchAdmDevVo.setNum(Integer.parseInt(request.getParameter("num")));

		// 데이터 조회
		AdmDevService admDevService = new AdmDevService();
		data = admDevService.getDev(srchAdmDevVo);
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
	
					document.getElementById("devForm").setAttribute("action", "/adm/step2/devProc.jsp");
					document.getElementById("devForm").submit();
				}
			}

			// 뒤로가기
			function goBack(){
				history.back();
			}

			// 목록 페이지 이동
			function goList(){
				location.href = "/adm/step2/devList.jsp";
			}
		</script>
	</head>
	<body>
		<form id="devForm" method="POST">
			<input type="hidden" id="procType" name="procType"/>
			<input type="hidden" id="num" name="num" value="<%=(data != null ? data.getNum() : "")%>"/>
			<input type="hidden" id="title" name="title" />
			<input type="hidden" id="cont" name="cont" />
			<input type="hidden" id="cateCd" name="cateCd" />
			<input type="hidden" id="noteYn" name="noteYn" />
		</form>
		<div>
			<b><%=(data == null ? "등록" : "수정")%> 페이지</b>
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
						<input type="text" id="detailTitle" style="width:99%;" value="<%=(data != null ? data.getTitle() : "")%>"/>
					</td>
				</tr>
				<tr>
					<th>카테고리</th>
					<td align="left">
						<select id="detailCateCd" style="width:100px;">
<%
	Map<String, String> cateCdMap = AdmDevUtil.getCateCdMap();

	for(Map.Entry<String, String> elem : cateCdMap.entrySet()){
		if(data != null && data.getCateCd() != null && data.getCateCd().equals(elem.getKey())){
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
						<input type="checkbox" id="detailNoteYn" <%if(data != null && data.getNoteYn().equals("Y")){%>checked="checked"<%}%>/>
					</td>
				</tr>
				<tr>
					<th>내용</th>
					<td>
						<textarea id="detailCont" style="width:99%; height:300px;"><%=(data != null && data.getCont() != null ? data.getCont() : "")%></textarea>
					</td>
				</tr>
			</tbody>
		</table>
	</body>
</html>