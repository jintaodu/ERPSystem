<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>人事仓库管理系统</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<jsp:include  page="common/head.jsp"></jsp:include>

  </head>
  


<frameset rows="120,*" cols="80%" frameborder="NO" border="0" framespacing="0">
  <frame src="ftop.htm" name="topFrame" scrolling="NO" noresize >
  <frameset cols="220,*" frameborder="NO" border="0" framespacing="0">
    <frame src="indexLeft.htm" name="leftFrame" scrolling="NO" noresize>
    <frame src="fmain.htm" name="mainFrame">
  </frameset>
</frameset>
  

<body>



  
<!-- <noframes>
</noframes> -->
<%

  /* if(session.getAttribute("username")==null)
  {
    response.sendRedirect("login.html");//无权访问本manage.jsp
  }else
  {
  	session.setMaxInactiveInterval(300);//五分钟无人操作session过期
  } */

 %>
</body>

</html>
