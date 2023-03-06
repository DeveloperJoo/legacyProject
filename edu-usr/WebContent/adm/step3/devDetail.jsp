<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/adm/step3/inc.jsp"%>
<%
	//검색 객체 설정
	AdmDevVo srchAdmDevVo = new AdmDevVo();
	srchAdmDevVo.setNum(Integer.parseInt(request.getParameter("num")));

	// 데이터 조회
	AdmDevService admDevService = new AdmDevService();
	AdmDevVo data = admDevService.getDev(srchAdmDevVo);
%>
<!DOCTYPE html>
<html>
	<head>
		<title>상세</title>
		<%@ include file="/adm/step3/incHtml.jsp"%>
		<script type="text/javascript">
			// 삭제 처리
			function procRemove(){
				if(confirm("삭제 하시겠습니까?")){
					var url = "/adm/step3/devProc.jsp";
					var params = {
						procType : "REMOVE",
						num : $("#num").val()
					};
	
					$.ajax({
						url : url,
					    type : "post",
					    data : params,
						dataType : "text",
						beforeSend : function(x){
							
						},
						success : function(data){
							alert("삭제 되었습니다.");
							goList();
						},
						error : function(xhr, status, error){
							alert("Ajax Error : " + xhr.status + " / " + xhr.statusText + " / " + xhr.responseText);
						},
						complete: function(x, status){
							
						}
					});
				}
			}

			// 수정 페이지 이동
			function goSave(){
				var num = $("#num").val();

				location.href = "/adm/step3/devSave.jsp?num=" + num;
			}

			// 목록 페이지 이동
			function goList(){
				location.href = "/adm/step3/devList.jsp";
			}
		</script>
	</head>
	<body>
		<input type="hidden" id="num" name="num" value="<%=data.getNum()%>" />
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
					<td colspan="3"><%=data.getTitle()%></td>
				</tr>
				<tr>
					<th>카테고리</th>
					<td align="center"><%=AdmDevUtil.getCateCdNm(data.getCateCd())%></td>
					<th>공지여부</th>
					<td align="center"><%=data.getNoteYn()%></td>
				</tr>
				<tr>
					<th>등록일</th>
					<td align="center"><%=AdmDevUtil.getDateFormat(data.getRegDt())%></td>
					<th>수정일</th>
					<td align="center"><%=AdmDevUtil.getDateFormat(data.getModDt())%></td>
				</tr>
				<tr>
					<th>내용</th>
					<td colspan="3" valign="top" style="white-space:pre;"><%=data.getCont() != null ? data.getCont() : ""%></td>
				</tr>
			</tbody>
		</table>
	</body>
</html>