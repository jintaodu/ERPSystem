<%@ page language="java" import="java.util.*" import="org.erpsystem.dao.*" pageEncoding="UTF-8"%>
<%@ page language="java" import="java.sql.*"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>发放工资</title>
    
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
	<div class="page-header"><h4>员工工资发放</h4></div>
		<form name="salaryform" method=POST >
		   	<div class="input-group input-group-lg col-md-6">
			  <span class="input-group-addon" id="sizing-addon1">员工姓名</span>
			  <select id="employeenamepicker" name="employeename" data-live-search="true" class="form-control col-md-4" style="display: none;"></select>
			</div>
		
			<br>
			<div class="input-group input-group-lg col-md-6">
			  <span class="input-group-addon" id="sizing-addon1">身份证号</span>
			  <input type="text" class="form-control  col-md-4" id="employeeidno" name="employeeidno" onfocus=this.blur()></input> 
			</div>
			
			<br>
			<div class="input-group input-group-lg col-md-6">
			  <span class="input-group-addon" id="sizing-addon1">工资（日薪）</span>
			  <input type="text" class="form-control  col-md-4" id="salary" name="salary"></input> 
			</div>
			
			<br>
			<div class="input-group input-group-lg col-md-6">
			  <span class="input-group-addon" id="sizing-addon1">上次发放日期</span>
			  <input type="text" class="form-control  col-md-4" id="salarylastdate" name="salarylastdate"></input> 
			</div>
			
			<br>
			<div class="input-group input-group-lg col-md-6">
			  <span class="input-group-addon" id="sizing-addon1">本次发放金额</span>
			  <input type="text" class="form-control  col-md-4" id="salaryamount" name="salaryamount"></input> 
			</div>

			<br>
			<input type="hidden" name="checktype" value="checkout"></input>
			<button name="submit1" id="submit1" type="button" class="btn btn-primary">提交</button>
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
			
			$('select#employeenamepicker').selectpicker();
			
			var selectedname = $("select[name=employeename]").val();
			var selectedidno = $("select#employeenamepicker").find("option:selected").attr("idno");
			var idnos = "";
			var checkindate="";
			var salarylastdate="";
			var salary="";
			for(var index in employeeinfo){
				if( employeeinfo[index].employeename == selectedname && employeeinfo[index].idno == selectedidno ){
					idnos          += index;
					checkindate    += employeeinfo[index].checkindate;
					salarylastdate  = employeeinfo[index].salarylastdate;
					salary          = employeeinfo[index].salary;
					break;
				}
			}
			console.log(salarylastdate);
			$("form[name=salaryform] input[name=employeeidno]").val(idnos);
			$("form[name=salaryform] input[name=checkindate]").val(checkindate);
			$("form[name=salaryform] input[name=salary]").val(salary);

			if(null == salarylastdate || salarylastdate.length == 0){
				salarylastdate = "未知";
			}
			$("form[name=salaryform] input[name=salarylastdate]").val(salarylastdate);
			
		}
	});
	
	//员工名下拉列表改变事件
	$('select[name=employeename]').change(function(){
		var selectedname = $("select[name=employeename]").val();
		var selectedidno = $("select#employeenamepicker").find("option:selected").attr("idno");
		
		var idnos = "";
		var checkindate="";
		var salarylastdate="";
		var salary="";
		
		for(var index in employeeinfo){
			if( employeeinfo[index].employeename == selectedname && employeeinfo[index].idno == selectedidno ){
				idnos          += index;
				checkindate    += employeeinfo[index].checkindate;
				salarylastdate  = employeeinfo[index].salarylastdate;
				salary          = employeeinfo[index].salary;
				break;
			}
		}
		console.log(salarylastdate);
		$("form[name=salaryform] input[name=employeeidno]").val(idnos);
		$("form[name=salaryform] input[name=checkindate]").val(checkindate);
		$("form[name=salaryform] input[name=salary]").val(salary);
		if(null == salarylastdate || salarylastdate.length == 0){
			salarylastdate="未知";
		}
		$("form[name=salaryform] input[name=salarylastdate]").val(salarylastdate);
		
	});
	
	
	$("button#submit1").click(function(event) {
		
		var salaryamount = $("input[name=salaryamount]").val();
		salaryamount = parseFloat(salaryamount);
		if(isNaN(salaryamount) || salaryamount < 0){
			alert("发放工资必须是数字，并且大于0");
			return;
		}
		
		var serializeArray = $("form[name=salaryform]").serialize();
		
		alert("serializeArray="+serializeArray);
		$.ajax({
			url: "/ERPSystem/hr/employeesalaryServlet",
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
				
				//alert(json.result);
				dialog_open(json);
				
			}
		});
	});
	
	
});

</script>

</html>
