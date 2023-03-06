<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/adm/step2/inc.jsp"%>
<%
	// 파라메터
	String procType = request.getParameter("procType");

	AdmDevUtil.sysLog("# 처리유형 : " + procType);

	// 처리 후 이동할 경로
	String resUrl = "/adm/step2/devList.jsp";

	AdmDevService admDevService = new AdmDevService();

	if(procType.equals("REMOVE")){
		int num = Integer.parseInt(request.getParameter("num"));

		AdmDevVo data = new AdmDevVo();
		data.setNum(num);

		int result = admDevService.remove(data);

		AdmDevUtil.sysLog("# 처리건수 : " + result);
	}else if(procType.equals("REMOVE_ALL")){
		String[] nums = request.getParameter("nums").split(",");
		List<AdmDevVo> dataList = new ArrayList<AdmDevVo>();

		for(int i=0; i<nums.length; i++){
			AdmDevVo data = new AdmDevVo();
			data.setNum(Integer.parseInt(nums[i]));

			dataList.add(data);
		}

		int result = admDevService.remove(dataList);

		AdmDevUtil.sysLog("# 처리건수 : " + result);
	}else if(procType.equals("CREATE") || procType.equals("MODIFY")){
		AdmDevVo data = new AdmDevVo();
		data.setTitle(request.getParameter("title"));
		data.setCont(request.getParameter("cont"));
		data.setCateCd(request.getParameter("cateCd"));
		data.setNoteYn(request.getParameter("noteYn"));

		// 등록 이라면
		if(procType.equals("CREATE")){
			int result = admDevService.create(data);

			AdmDevUtil.sysLog("# 처리건수 : " + result);
		}else{
			data.setNum(Integer.parseInt(request.getParameter("num")));

			int result = admDevService.modify(data);

			AdmDevUtil.sysLog("# 처리건수 : " + result);
		}

		resUrl = "/adm/step2/devDetail.jsp?num=" + data.getNum();
	}

	response.sendRedirect(resUrl);
%>