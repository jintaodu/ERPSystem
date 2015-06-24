<%@ page language="java" import="java.util.*" import="org.erpsystem.dao.*" pageEncoding="UTF-8"%>
<%@ page language="java" import="java.sql.*"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>员工签入签出</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	
	<jsp:include  page="/common/head.jsp"></jsp:include>

  </head>

<body>
   
   <div id="dialog" style="display: none" title="">
  		<p></p>
   </div>
   
   <div class="col-md-12">
		
		<div class="page-header"><h4>老员工离职</h4></div>
	
		<form name="checkoutform" method=POST >
		   	<div class="input-group input-group-lg col-md-6">
			  <span class="input-group-addon" id="sizing-addon1">员工姓名</span>
			  <select id="employeenamepicker" name="employeeName" data-live-search="true" class="form-control col-md-4" style="display: none;"></select>
			</div>
		
			<br>
			<div class="input-group input-group-lg col-md-6">
			  <span class="input-group-addon" id="sizing-addon1">身份证号</span>
			  <input type="text" class="form-control  col-md-4" id="employeeidno" name="employeeidno" onfocus=this.blur() ></input> 
			</div>
			
			<br>
			<div class="input-group input-group-lg col-md-6">
			  <span class="input-group-addon" id="sizing-addon1">工资（日薪）</span>
			  <input type="text" class="form-control  col-md-4" id="salary" name="salary"></input> 
			</div>
			
			<br>
			<div class="input-group input-group-lg col-md-6">
			  <span class="input-group-addon" id="sizing-addon1">工资发放至</span>
			  <input type="text" class="form-control  col-md-4" id="salarylastdate" name="salarylastdate"></input> 
			</div>
			
			<br>
			<input type="hidden" name="checktype" value="checkout"></input>
			<button name="submit2" id="submit2" type="button" class="btn btn-primary">提交</button>
		</form>
	
	</div>
	
  </body>
  
<script type="text/javascript">



$(function() {
	
	var employeeinfo = null;
	$.ajax({
		url: "/ERPSystem/hr/employeebrowseServlet",
		data:{"browsetype":"onlyonsite"},
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
			
			var selecthtml = "";
			for(var index in employeeinfo){
				selecthtml += "<option value="+employeeinfo[index].employeename+" idno="+employeeinfo[index].idno+">"
				+employeeinfo[index].employeename+"(身份证号："+employeeinfo[index].idno+")</option>";
			}
			
			$("select#employeenamepicker").html(selecthtml);
			
			$('#employeenamepicker').selectpicker();
			
			var selectedname = $("select#employeenamepicker").val();
			var selectedidno = $("select#employeenamepicker").find("option:selected").attr("idno"); 
			var idnos = "", salary="";
			var checkindate="";
			var salarylastdate="";
			for(var index in employeeinfo){
				if(employeeinfo[index].employeename == selectedname && employeeinfo[index].idno == selectedidno){
					idnos          += index;
					checkindate    += employeeinfo[index].checkindate;
					salarylastdate  = employeeinfo[index].salarylastdate;
					salary          = employeeinfo[index].salary;
					break;
				}
			}
			$("form[name=checkoutform] input#employeeidno").val(idnos);
			$("form[name=checkoutform] input#checkindate").val(checkindate);
			if(null == salarylastdate || salarylastdate.length == 0){
				salarylastdate="未知";
			}
			$("form[name=checkoutform] input#salary").val(salary);
			$("form[name=checkoutform] input#salarylastdate").val(salarylastdate);
		}
	});
	
	//员工名下拉列表改变事件
	$('select#employeenamepicker').change(function(){
		var selectedname = $("select#employeenamepicker").val();
		var selectedidno = $("select#employeenamepicker").find("option:selected").attr("idno"); 
		
		var idnos = "";
		var checkindate="";
		var salarylastdate="", salary="";
		for(var index in employeeinfo){
			if( employeeinfo[index].employeename == selectedname && employeeinfo[index].idno == selectedidno){
				idnos         += index;
				checkindate   += employeeinfo[index].checkindate;
				salarylastdate = employeeinfo[index].salarylastdate;
				salary         = employeeinfo[index].salary;
				break;
			}
		}
		
		$("form[name=checkoutform] input#employeeidno").val(idnos);
		$("form[name=checkoutform] input#checkindate").val(checkindate);
		$("form[name=checkoutform] input#salary").val(salary);
		if(null == salarylastdate || salarylastdate.length == 0){
			salarylastdate="未知";
		}
		$("form[name=checkoutform] input#salarylastdate").val(salarylastdate);
		
	});
	

/* 	$("button#submit1").click(function(event) {
		
		var employeename = $("form[name=checkinform] input#employeeName").val();
		var employeeidno = $("form[name=checkinform] input#employeeidno").val();
		var salary       = $("form[name=checkinform] input#salary").val();
			salary       = parseFloat(salary);
		if(employeename.length == 0){
			alert("员工姓名不能为空！");
			return;
		}
		if(employeeidno.length == 0 ){
			alert("身份证号不能为空！且必须完全是数字！");
			return;
		}
		if(isNaN(salary) || salary < 0){
			alert("工资必须是数字，并且大于0");
			return;
		}
		
		var serializeArray = $("form[name=checkinform]").serialize();
		alert
		alert("serializeArray="+serializeArray);
		$.ajax({
			url: "/ERPSystem/hr/employeecheckinoutServlet",
			data: serializeArray,
			type: "post",
			async: false,
			dataType: 'json',
			error: function(xhr, message, obj) {
				
		        console.log("ERR:",xhr.responseText, message, obj);	
				alert("计算出错了，请检查参数！");
				return;
			},
			success:function(json){
				
				alert(json.result);

			}
		});
	}); */
	
	
 	$("button#submit2").click(function(event) {
		
 		var employeename = $("form[name=checkoutform] select option:selected").val();
		var employeeidno = $("form[name=checkoutform] input[name=employeeidno]").val();

		if(employeename.length == 0){
			alert("员工姓名不能为空！");
			return;
		}
		if(employeeidno.length == 0 ){
			alert("身份证号不能为空！且必须完全是数字！");
			return;
		}

		var serializeArray = $("form[name=checkoutform]").serialize();
		
		alert("serializeArray="+serializeArray);
		$.ajax({
			url: "/ERPSystem/hr/employeecheckinoutServlet",
			data: serializeArray,
			type: "post",
			async: false,
			dataType: 'json',
			error: function(xhr, message, obj) {
				
		        console.log("ERR:",xhr.responseText, message, obj);	
		        console.log(xhr.responseText);
				alert("计算出错了，请检查参数！");
				return;
			},
			success:function(json){
				
				//alert(json.result);
				dialog_open(json);
			}
		});
	}); 
	
	
});

</script>

</html>
