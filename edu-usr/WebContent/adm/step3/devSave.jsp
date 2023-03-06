<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/adm/step3/inc.jsp"%>
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
		<%@ include file="/adm/step3/incHtml.jsp"%>
		<script type="text/javascript">
			// 저장
			function procSave(){
				if($("#detailTitle").val() == ""){
					alert("제목을 입력 해 주세요.");
					$("#detailTitle").focus();
					return;
				}

				var procType = "CREATE";
				var msg = "등록";

				// 수정 이라면
				if($("#num").val() != ""){
					procType = "MODIFY";
					msg = "수정";
				}

				if(confirm(msg + " 하시겠습니까?")){
					var url = "/adm/step3/devProc.jsp";
					var params = {
						procType : procType,
						num : $("#num").val(),
						title : $("#detailTitle").val(),
						cont : $("#detailCont").val(),
						cateCd : $("#detailCateCd").val(),
						noteYn : $("#detailNoteYn").is(":checked") ? "Y" : "N"
					};

					$.ajax({
						url : url,
					    type : "post",
					    data : params,
						dataType : "text",
						beforeSend : function(x){
							
						},
						success : function(data){
							alert(msg + " 되었습니다.");

							if(procType == "CREATE"){
								$("#num").val(data);
							}

							goDetail($("#num").val());
						},
						error : function(xhr, status, error){
							alert("Ajax Error : " + xhr.status + " / " + xhr.statusText + " / " + xhr.responseText);
						},
						complete: function(x, status){
							
						}
					});
				}
			}

			// 뒤로가기
			function goBack(){
				history.back();
			}

			// 목록 페이지 이동
			function goList(){
				location.href = "/adm/step3/devList.jsp";
			}

			// 상세 페이지로 이동
			function goDetail(num){
				location.href = "/adm/step3/devDetail.jsp?num=" + num;
			}
		</script>
	</head>
	<body>
		<input type="hidden" id="num" name="num" value="<%=(data != null ? data.getNum() : "")%>"/>
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