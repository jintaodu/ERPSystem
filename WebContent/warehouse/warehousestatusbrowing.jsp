<%@ page language="java" import="java.util.*" import="org.erpsystem.dao.*" import="java.sql.*" pageEncoding="UTF-8"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>

<head> 
   <title>My JSP 'selectCurrentItems.jsp' starting page</title>
   
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">    
<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
<meta http-equiv="description" content="This is my page">

<jsp:include  page="/common/head.jsp"></jsp:include>

</head>
  
<body>
   
   <div class="col-md-12">
       <div class="page-header"><h4>查看货物库存量</h4></div>
    	<button name="print" id="print" class="btn btn-primary">打印</button>
    	<div class="col-md-12">
	        <table id="historytable" class="datatable display">
	    	<thead>
	               <tr>
	                   <th>货物名</th>
	                   <th>货物类型</th>
	                   <th>货物位置</th>
	                   <th>货物库存量</th>
	               </tr>
	         </thead>
	         </table>
       </div>

	</div>
   
  </body>
  
  <script type="text/javascript">

  var table = $('#historytable').DataTable({
	  "oLanguage": {               //汉化
          "sLengthMenu": "每页显示 _MENU_ 条记录",
          "sZeroRecords": "没有检索到数据",
          "sInfo": "当前数据为从第 _START_ 到第 _END_ 条数据；总共有 _TOTAL_ 条记录",
          "sInfoFiltered": "(从 _MAX_ 条记录中过滤)",
          "sInfoEmtpy": "没有数据",
          "sSearch": "搜索：",
          "sProcessing": "正在加载数据...",
          "oPaginate": {
              "sFirst": "首页",
              "sPrevious": "前页",
              "sNext": "后页",
              "sLast": "尾页"
          }
      }
  });
  
  
  function productinfo_render()
  {   //获取仓库的库存信息
	  $.ajax({
		  url: "/ERPSystem/warehouse/productbrowseServlet",
			data:{"browsetype":"statustable"},
			type: "get",
			async: false,
			dataType: 'json',
			error: function(xhr, message, obj) {
				
		        console.log("ERR:" , xhr.responseText, message, obj);	
				alert("获取仓库信息出错了，请检查参数！");
				return;
			},
			success:function(json){
				console.log(json);
 				table.clear();
			    table.rows.add(json).draw(); 
			}
		  
		  
	  });
   }
  $(function(){
	  productinfo_render();

	   $("button#print").click(function(){
		  window.print();
	  });

	
  });
  </script>
  
</html>


