<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ include file="/adm/step3/inc.jsp"%>
<%
	// 검색 객체 설정
	AdmDevVo srchAdmDevVo = new AdmDevVo();
	srchAdmDevVo.setTitle(request.getParameter("title"));
	srchAdmDevVo.setCateCd(request.getParameter("cateCd"));
	srchAdmDevVo.setNoteYn(request.getParameter("noteYn"));

	// 데이터 조회
	AdmDevService admDevService = new AdmDevService();
	List<AdmDevVo> dataList = admDevService.getDevList(srchAdmDevVo);

	if(dataList != null){
		for(AdmDevVo data : dataList){
			out.println("<tr num='" + data.getNum() + "'>");
			out.println("	<td align='center'><input type='checkbox'/></td>");
			out.println("	<td align='center'>" + data.getNum() + "</td>");
			out.println("	<td><a href='javascript:goDetail(" + data.getNum() + ");'>" + data.getTitle() + "</a></td>");
			out.println("	<td align='center'>" + AdmDevUtil.getCateCdNm(data.getCateCd()) + "</td>");
			out.println("	<td align='center'>" + data.getNoteYn() + "</td>");
			out.println("	<td align='center'>" + AdmDevUtil.getDateFormat(data.getRegDt()) + "</td>");
			out.println("	<td align='center'>" + AdmDevUtil.getDateFormat(data.getModDt()) + "</td>");
			out.println("</tr>");
		}
	}
%>