<%@ page language="java" import="java.util.*" import="org.erpsystem.dao.*" pageEncoding="UTF-8"%>
<%@ page language="java" import="java.sql.*"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>货物入仓登记</title>
    
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
	<div class="page-header"><h4>货物入仓登记</h4></div>
	
	<form name = "checkinform" method=POST>
		
		<div class="input-group input-group-lg col-md-6">
			  <span class="input-group-addon" id="sizing-addon1">货物名称</span>
			  <input id="productname" name="productname" type="text" class="form-control  col-md-4" autocomplete="off">
		</div>
		<br>
		<div class="input-group input-group-lg col-md-6">
			  <span class="input-group-addon" id="sizing-addon1">货物型号</span>
			  <input id="producttype" name="producttype" type="text" class="form-control  col-md-4" autocomplete="off">
		</div>
		<br>
		<div class="input-group input-group-lg col-md-6">
			  <span class="input-group-addon" id="sizing-addon1">存放位置</span>
			  <input id="productlocation" name="productlocation" type="text" class="form-control  col-md-4" autocomplete="off">
		</div>
		
		<br>
		<div class="input-group input-group-lg col-md-6">
			  <span class="input-group-addon" id="sizing-addon1">入仓数量</span>
			  <input id="checkinamount" name="checkinamount" type="text" class="form-control  col-md-4" autocomplete="off">
		</div>
		<br>
		<input type="hidden" name="checktype" value="checkin"></input>
		<button name="submit1" id="submit1" type="button" class="btn btn-primary">提交</button>
	</form>
	
	</div>
	
	
  </body>
  
<script type="text/javascript">

	
	var productinfo = null;
	
	function productnamepicker_change(){

		var selectedname = $("select#productnamepicker").val();
		var selecthtml = "";
	
		var producttypearray = new Array();
		for(var index in productinfo){
			var producttype = productinfo[index].producttype;
			if( productinfo[index].productname == selectedname && producttypearray.indexOf( producttype )==-1 ){
				producttypearray.push( producttype );
			}
		}
		
		for(var index in producttypearray){
			selecthtml += "<option value="+producttypearray[index]+">"+producttypearray[index]+"</option>";
		}
		$("select#producttypepicker").html(selecthtml);
		
		$('select#producttypepicker').selectpicker('refresh');//重新渲染selectpicker

	}
	
	function producttypepicker_change(){
		
		var selectedtype = $("select#producttypepicker").val();
		var selectedname = $("select#productnamepicker").val();
		
		var selecthtml = "";
		//alert(selectedtype);
		//alert(selectedname);
		var productlocationarray = new Array();
		
		for(var index in productinfo){
			//alert(productinfo[index].productname+"    "+productinfo[index].producttype);
			if( productinfo[index].productname == selectedname && productinfo[index].producttype ==  selectedtype ){
				selecthtml += "<option value=" + productinfo[index].productlocation + ">" + productinfo[index].productlocation + "</option>";
			}
		}
		
		$("select#productlocationpicker").html(selecthtml);
		
		$('select#productlocationpicker').selectpicker('refresh');//重新渲染selectpicker
		
	}
	
	function productlocationpicker_change(){
		
		var selectedtype     = $("select#producttypepicker").val();
		var selectedname     = $("select#productnamepicker").val();
		var selectedlocation = $("select#productlocationpicker").val();
		
		for(var index in productinfo){
			if( productinfo[index].productname == selectedname && productinfo[index].producttype == selectedtype && productinfo[index].productlocation == selectedlocation ){
				console.log(productinfo[index].productamount);
				
				$("label#remainamount").text(productinfo[index].productamount);	
			
			}
		}
	}
	
	
$(function() {

	  //获取仓库的库存信息
	  $.ajax({
		  url: "/ERPSystem/warehouse/productbrowseServlet",
			data:{"browsetype":"all"},
			type: "get",
			async: false,
			dataType: 'json',
			error: function(xhr, message, obj) {
				
		        console.log("ERR:",xhr.responseText, message, obj);	
				alert("获取仓库信息出错了，请检查参数！");
				return;
			},
			success:function(json){
				
				productinfo = json;
				//以下完成checkin form的动作
				
				var productnames = new Array();
 				for(var index in productinfo){
 					if(productnames.indexOf(productinfo[index].productname) == -1){
 						productnames.push(productinfo[index].productname);
 						console.log(productinfo[index].productname);
 					}
 				}
				$("input#productname").autocomplete({
				    source: productnames
				});
				
				var productlocations = new Array();
 				for(var index in productinfo){
 					if(productlocations.indexOf(productinfo[index].productlocation) == -1){
 						productlocations.push(productinfo[index].productlocation);
 						console.log(productinfo[index].productlocation);
 					}
 				}
 				
				$("input#productlocation").autocomplete({
				    source: productlocations
				});
				
				
				//以下完成check out form的动作
				/* var selecthtml = "";
				var productnamearray = new Array();
				for(var index in productinfo){
					if( productnamearray.indexOf(productinfo[index].productname)==-1 ){
						productnamearray.push(productinfo[index].productname);	
					}
				}
				for(var index in productnamearray ){
					selecthtml += "<option value="+productnamearray[index]+">"+productnamearray[index]+"</option>";
				}
				$("select#productnamepicker").html(selecthtml);
				
				$('#productnamepicker').selectpicker();
				
				productnamepicker_change();
				producttypepicker_change();
				productlocationpicker_change(); */
			}
	  });
	  
	  
		//以下完成checkin form的动作绑定
	  $('input#productname').blur(function(){
	  		var producttypes = new Array();
	  		var productname = $("input#productname").val();
	  		console.log("productname="+productname);
	  		for(var index in productinfo){
	  			if(productinfo[index].productname == productname && producttypes.indexOf(productinfo[index].producttype)==-1){
	  				producttypes.push(productinfo[index].producttype);
	  			}
	  		}
	  		console.log(producttypes);
	  		$("input#producttype").autocomplete({
			    source: producttypes
			});
	  });
	  
	  
		//以下完成checkout form的动作绑定
		//货物名下拉列表改变事件
		/* $('select#productnamepicker').change(function(){
		
			productnamepicker_change();
			producttypepicker_change();
			productlocationpicker_change();
			
		}); */
		
		//货物类型下拉列表改变事件
		/* $('select#producttypepicker').change(function(){
		
			producttypepicker_change();
			productlocationpicker_change();
			
		}); */
		
		//货物位置下拉列表改变事件
		/* $('select#productlocationpicker').change(function(){
		
			productlocationpicker_change();
			
		}); */
	
	
	$("button#submit1").click(function(event) {
		
		var productname     = $("form[name=checkinform] input[name=productname]").val();
		var producttype     = $("form[name=checkinform] input[name=producttype]").val();
		var productlocation = $("form[name=checkinform] input[name=productlocation]").val();
		var checkinamount   = $("form[name=checkinform] input[name=checkinamount]").val();
		    checkinamount   = parseInt(checkinamount);
		
		if(productname.length == 0){
			alert("请输入货物名！");
			return;
		}else if(producttype.length == 0){
			alert("请输入货物型号！");
			return;
		}else if(productlocation.length == 0){
			alert("请输入货物存放位置！");
			return;
		}else if(isNaN(checkinamount) || checkinamount < 0){
			alert("入仓数量必须是数字，并且大于0");
			return;
		}
		
		var serializeArray = $("form[name=checkinform]").serialize();
		
		alert("serializeArray="+serializeArray);
		$.ajax({
			url: "/ERPSystem/warehouse/productcheckinoutServlet",
			data: serializeArray,
			type: "post",
			async: false,
			dataType: 'json',
			error: function(xhr, message, obj) {
				
		        console.log("ERR:",xhr.responseText, message, obj);	
				alert("货物入仓计算出错了，请检查参数！");
				return;
			},
			success:function(json){
				//$( "#dialog p" ).text(json.result);
				//$( "#dialog" ).dialog( "open" );
				dialog_open(json);
				//alert(json.result);
				//return;
			}
		});
	});
	
	
/* 	$("button#submit2").click(function(event) {
		
		var productname     = $("form[name=checkoutform] select[name=productname]").val();
		var producttype     = $("form[name=checkoutform] select[name=producttype]").val();
		var productlocation = $("form[name=checkoutform] select[name=productlocation]").val();
		
		var checkoutamount  = $("form[name=checkoutform] input[name=checkoutamount]").val();
		    checkoutamount  = parseInt(checkoutamount);
		var remainamount    = $("form[name=checkoutform] label[name=remainamount]").text();
			remainamount    = parseInt(remainamount);

		if(productname.length == 0){
			alert("请输入货物名！");
			return;
		}else if(producttype.length == 0){
			alert("请输入货物型号！");
			return;
		}else if(productlocation.length == 0){
			alert("请输入货物存放位置！");
			return;
		}else if(isNaN(checkoutamount) || checkoutamount < 0){
			alert("出仓数量必须是数字，并且大于0");
			return;
		}else if(checkoutamount > remainamount){
			alert("签出量大于库存量！");
			return;
		}
		
		var serializeArray = $("form[name=checkoutform]").serialize();
		
		alert("serializeArray="+serializeArray);
		$.ajax({
			url: "/ERPSystem/warehouse/productcheckinoutServlet",
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
				return;

			}
		});
	}); */
	
	
});

</script>

</html>
