<%@ page language="java" import="java.util.*" import="org.erpsystem.dao.*" import="java.sql.*" pageEncoding="UTF-8"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head> 
    <title>My JSP 'employeebrowsing.jsp' starting page</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	
	<jsp:include  page="/common/head.jsp"></jsp:include>
	
  </head>
  
  <body>
  
	<div class="col-md-12">
		<div class="page-header"><h4>查看员工状态</h4></div>
		
		<form name="employeebrowsing" method=POST >
		   	<div class="input-group input-group-lg col-md-6">
			  <span class="input-group-addon" id="sizing-addon1">员工姓名：</span>
			  <select id="employeenamepicker" data-live-search="true" class="form-control col-md-4" style="display: none;"></select>
			</div>
		
			<br>
			<div class="input-group input-group-lg col-md-6">
			  <span class="input-group-addon" id="sizing-addon1">身份证号：</span>
			  <input type="text" class="form-control  col-md-4" id="employeeidno"></input> 
			</div>
			
			<!-- <br>
			<input type="hidden" name="browsetype" value="all"></input>
			<button name="submit1" id="submit1" type="submit" class="btn btn-primary">查询</button> -->
		</form>
		
	<div class="page-header"><h4>员工基本状态</h4></div>
	
	<div class="col-md-12" id="summary">
    <table border=1 class="table table-hover">
       <tr >
       	<td width="200px"><b>用户名</b></td>
       	<td width="200px"><b>是否在职</b></td>
       	<td width="200px"><b>工资</b></td>
       	<td width="200px"><b>入职时间</b></td>
       	<td width="200px"><b>离职时间</b></td>
       	<td width="200px"><b>工资发放至</b></td>
       </tr>
       <tr id="result"></tr>
    </table>
    </div>
    
    <div class="page-header"><h4>员工历史记录</h4></div>
    
    <div class="col-md-12">
        <table id="historytable" class="datatable display">
    	<thead>
               <tr>
                   <th>身份证号</th>
                   <th>用户名</th>
                   <th>操作类型</th>
                   <th>时间</th>
                   <th>操作详情</th>
               </tr>
         </thead>
         </table>
    </div>
    
    
	</div>



  </body>
  
  <script type="text/javascript">
  
  var table = $('#historytable').DataTable({
	  "oLanguage": {//汉化
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
  
  
  function historyinfo_render(idno)
  {//根据身份证号获取历史信息,并进行渲染
	  $.ajax({
		  url: "/ERPSystem/hr/employeebrowseServlet",
			data:{"browsetype":"history","idno":idno},
			type: "get",
			async: false,
			dataType: 'json',
			error: function(xhr, message, obj) {
				
		        console.log("ERR:",xhr.responseText, message, obj);	
				alert("获取员工历史信息计算出错了，请检查参数！");
				return;
			},
			success:function(json){
				console.log(json);
 				table.clear();
			    table.rows.add(json).draw(); 
			}
		  
		  
	  });
   }
  
  $(function() {
	  
		var employeeinfo = null;
		$.ajax({
			url: "/ERPSystem/hr/employeebrowseServlet",
			data:{"browsetype":"all"},
			type: "get",
			async: false,
			dataType: 'json',
			error: function(xhr, message, obj) {
				
		        console.log("ERR:",xhr.responseText, message, obj);	
				alert("获取员工基本信息计算出错了，请检查参数！");
				return;
			},
			success:function(json){
				
				employeeinfo = json;
				//var selecthtml = "<select name=\"employeeName\" style=\"width:200px;\">";
				var selecthtml = "";
				for(var index in employeeinfo){
					selecthtml += "<option value="+employeeinfo[index].employeename+">"+employeeinfo[index].employeename+"</option>";
				}
				//selecthtml += "</select>";
				$("select#employeenamepicker").html(selecthtml);
				
				$('#employeenamepicker').selectpicker();
				
				var selectedname = $("select#employeenamepicker").val();
				var idnos = "", onsite = "", salary = "";
				var checkindate = "", checkoutdate = "", salarylastdate="";
				var prefix = "<td width=\"200px\">"
				var result = "";
				
				for(var index in employeeinfo){
					if(employeeinfo[index].employeename == selectedname){
						idnos          = index;
						salary         =  employeeinfo[index].salary;
						checkindate    =  employeeinfo[index].checkindate;
						onsite         =  employeeinfo[index].onsite;
						checkoutdate   =  employeeinfo[index].checkoutdate;
						if(null == onsite || onsite.length == 0) onsite="未知";
						if("1" == onsite) onsite="在职";
						else if("0" == onsite) onsite="已离职";
						
						if(null == checkoutdate || checkoutdate.length == 0) checkoutdate = "未知";
						salarylastdate =  employeeinfo[index].salarylastdate;
						if(null == salarylastdate || salarylastdate.length == 0) salarylastdate = "未知";
						result         += prefix + selectedname + "</td>";
						result         += prefix + onsite+"</td>";
						result         += prefix + salary+"</td>";
						result         += prefix + checkindate+"</td>";
						result         += prefix + checkoutdate+"</td>";
						result         += prefix + salarylastdate+"</td>";
						break;
					}
				}

				$("form[name=employeebrowsing] input#employeeidno").val(idnos);
				$("div#summary tr#result").html(result);
				
				historyinfo_render(idnos);
	
			}
		});
		
		//员工名下拉列表改变事件
		$('select#employeenamepicker').change(function(){
			var selectedname = $("select#employeenamepicker").val();

			var idnos = "", onsite = "", salary = "";
			var checkindate = "", checkoutdate = "", salarylastdate="";
			var prefix = "<td width=\"200px\">"
			var result = "";
			
			for(var index in employeeinfo){
				if(employeeinfo[index].employeename == selectedname){
					idnos          = index;
					salary         =  employeeinfo[index].salary;
					checkindate    =  employeeinfo[index].checkindate;
					onsite         =  employeeinfo[index].onsite;
					checkoutdate   =  employeeinfo[index].checkoutdate;
					
					if(null == onsite || onsite.length == 0) onsite="未知";
					if("1" == onsite) onsite="在职";
					else if("0" == onsite) onsite="已离职";
					
					if(null == checkoutdate || checkoutdate.length == 0) checkoutdate = "未知";
					salarylastdate =  employeeinfo[index].salarylastdate;
					if(null == salarylastdate || salarylastdate.length == 0) salarylastdate = "未知";
					result         += prefix + selectedname + "</td>";
					result         += prefix + onsite+"</td>";
					result         += prefix + salary+"</td>";
					result         += prefix + checkindate+"</td>";
					result         += prefix + checkoutdate+"</td>";
					result         += prefix + salarylastdate+"</td>";
					break;
				}
			}
			$("form[name=employeebrowsing] input#employeeidno").val(idnos);
			$("div#summary tr#result").html(result);
			historyinfo_render(idnos);
		});
		
  });
  
  
		
		
  </script>
  
</html>


