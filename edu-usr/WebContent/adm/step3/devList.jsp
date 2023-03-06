<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/adm/step3/inc.jsp"%>
<!DOCTYPE html>
<html>
	<head>
		<title>목록</title>
		<%@ include file="/adm/step3/incHtml.jsp"%>
		<script type="text/javascript">
			$(document).ready(function(){
				$("#srchVal").keydown(function(event){
					// 엔터키 입력시 조회 실행
					if(event.keyCode == 13) {
						srch();
					}
				});

				// 조회
				srch();
			});

			// 조회
			function srch(){
				var url = "/adm/step3/devListData.jsp";
				var params = {
					title : $("#srchVal").val(),
					cateCd : $("#srchCateCd").val(),
					noteYn : $("#srchNoteYn").checked ? "Y" : "N"
				};

				$.ajax({
					url : url,
				    type : "post",
				    data : params,
					dataType : "text",
					beforeSend : function(x){
						
					},
					success : function(data){
						$("#dataTableBody").html(data);
					},
					error : function(xhr, status, error){
						alert("Ajax Error : " + xhr.status + " / " + xhr.statusText + " / " + xhr.responseText);
					},
					complete: function(x, status){
						
					}
				});
			}

			// 선택 삭제 처리
			function procRemoveAll(){
				var nums = "";

				$("#dataTableBody input[type='checkbox']:checked").each(function(){
					if(nums != ""){
						nums += ",";
					}

					nums += $(this).closest("tr[num]").attr("num");
				});

				if(nums == ""){
					alert("삭제할 데이터를 선택 해 주세요.");
					return;
				}

				if(confirm("선택 데이터를 삭제 하시겠습니까?")){
					var url = "/adm/step3/devProc.jsp";
					var params = {
						procType : "REMOVE_ALL",
						nums : nums
					};

					$.ajax({
						url : url,
					    type : "post",
					    data : params,
						dataType : "text",
						beforeSend : function(x){
							
						},
						success : function(data){
							alert(data + "건이 삭제 되었습니다.");
							srch();
						},
						error : function(xhr, status, error){
							alert("Ajax Error : " + xhr.status + " / " + xhr.statusText + " / " + xhr.responseText);
						},
						complete: function(x, status){
							
						}
					});
				}
			}

			// 전체 체크
			function setAllCheck(flag){
				$("#dataTableBody input[type='checkbox']").each(function(){
					$(this).prop("checked", flag);
				});
			}

			// 등록 페이지 이동
			function goSave(){
				location.href = "/adm/step3/devSave.jsp";
			}

			// 상세 페이지로 이동
			function goDetail(num){
				location.href = "/adm/step3/devDetail.jsp?num=" + num;
			}
		</script>
	</head>
	<body>
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
						<input type="text" id="srchVal" style="width:99%;"/>
					</td>
					<th>카테고리</th>
					<td align="center">
						<select id="srchCateCd" style="width:100px;">
							<option value="">전체</option>
<%
	Map<String, String> cateCdMap = AdmDevUtil.getCateCdMap();

	for(Map.Entry<String, String> elem : cateCdMap.entrySet()){
		out.println("<option value='" + elem.getKey() + "'>" + elem.getValue() + "</option>");
	}
%>
						</select>
					</td>
					<th>공지여부</th>
					<td align="center">
						<input type="checkbox" id="srchNoteYn"/>
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
			<tbody id="dataTableBody"></tbody>
		</table>
	</body>
</html>