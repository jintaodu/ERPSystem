<%@ page language="java" import="java.util.*" import="org.erpsystem.dao.*" pageEncoding="UTF-8"%>
<%@ page language="java" import="java.sql.*"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>货物出仓登记</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	
	<jsp:include  page="/common/head.jsp"></jsp:include>

  </head>

<body>
   <div id="dialog" style="display: none" title="基本的对话框">
  		<p></p>
   </div>
<div class="col-md-12">
		
	<div class="page-header"><h4>货物出仓登记</h4></div>

	<form name="checkoutform" method=POST >
	   	<div class="input-group input-group-lg col-md-6">
		  <span class="input-group-addon" id="sizing-addon1">货物名称</span>
		  <select id="productnamepicker" name="productname" data-live-search="true" class="form-control col-md-4" style="display: none;"></select>
		</div>
	
		<br>
		<div class="input-group input-group-lg col-md-6">
		  <span class="input-group-addon" id="sizing-addon1">货物型号</span>
		  <select id="producttypepicker" name="producttype" data-live-search="true" class="form-control col-md-4" style="display: none;"><option value="无">无</option></select>
		</div>
		
		<br>
		<div class="input-group input-group-lg col-md-6">
		  <span class="input-group-addon" id="sizing-addon1">存放位置</span>
		  <select id="productlocationpicker" name="productlocation" data-live-search="true" class="form-control col-md-4" style="display: none;"><option value="无">无</option></select>
		</div>
		
		<br>
		<div class="input-group input-group-lg col-md-6">
		  <span class="input-group-addon" id="sizing-addon1">库存数量</span>
		  <input type="text" class="form-control  col-md-4" id="remainamount" name="remainamount" onfocus=this.blur()></input> 
		</div>
		
		<br>
		<div class="input-group input-group-lg col-md-6">
		  <span class="input-group-addon" id="sizing-addon1">出仓数量</span>
		  <input type="text" class="form-control  col-md-4" id="checkoutamount" name="checkoutamount"></input> 
		</div>
		
		<br>
		<input type="hidden" name="checktype" value="checkout"></input>
		<button name="submit2" id="submit2" type="button" class="btn btn-primary">提交</button>
	</form>
	
	</div>
	
	
  </body>
  
<script type="text/javascript">


	$('#producttypepicker').selectpicker();
	$('#productlocationpicker').selectpicker();
	
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
		
		var selectedindex = $("select#producttypepicker").get(0).selectedIndex;
		//alert("produtcttypeindex="+selectedindex);
		$("select#producttypepicker").html(selecthtml);
		
		if(null != selectedindex){
			$("select#producttypepicker").get(0).selectedIndex = selectedindex;
		}
		
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
		
		var selectedindex = $("select#productlocationpicker").get(0).selectedIndex;
		$("select#productlocationpicker").html(selecthtml);
		if(null != selectedindex){
			$("select#productlocationpicker").get(0).selectedIndex = selectedindex;
		}
		
		$('select#productlocationpicker').selectpicker('refresh');//重新渲染selectpicker
		
	}
	
	function productlocationpicker_change(){
		
		var selectedtype     = $("select#producttypepicker").val();
		var selectedname     = $("select#productnamepicker").val();
		var selectedlocation = $("select#productlocationpicker").val();
		
		for(var index in productinfo){
			if( productinfo[index].productname == selectedname && productinfo[index].producttype == selectedtype && productinfo[index].productlocation == selectedlocation ){
				console.log(productinfo[index].productamount);
				
				$("input#remainamount").val(productinfo[index].productamount);	
			
			}
		}
	}
	
	function getproductinfo(){
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
					//以下完成checkout form的动作
					var selecthtml = "";
					var productnamearray = new Array();
					for(var index in productinfo){
						if( productnamearray.indexOf(productinfo[index].productname)==-1 ){
							productnamearray.push(productinfo[index].productname);	
						}
					}
					for(var index in productnamearray ){
						selecthtml += "<option value="+productnamearray[index]+">"+productnamearray[index]+"</option>";
					}
					
					var selectedindex = $("select#productnamepicker").get(0).selectedIndex;
					$("select#productnamepicker").html(selecthtml);
					
					if(null != selectedindex){
						$("select#productnamepicker").get(0).selectedIndex = selectedindex;
					}
					
					$('#productnamepicker').selectpicker();
					
					productnamepicker_change();
					producttypepicker_change();
					productlocationpicker_change();
				}
		  });
	}
	
	
$(function() {
  
		getproductinfo();
	
		//以下完成checkout form的动作绑定
		//货物名下拉列表改变事件
		$('select#productnamepicker').change(function(){
		
			productnamepicker_change();
			producttypepicker_change();
			productlocationpicker_change();
			
		});
		
		//货物类型下拉列表改变事件
		$('select#producttypepicker').change(function(){
		
			producttypepicker_change();
			productlocationpicker_change();
			
		});
		
		//货物位置下拉列表改变事件
		$('select#productlocationpicker').change(function(){
		
			productlocationpicker_change();
			
		});
	
	
	$("button#submit2").click(function(event) {
		
		var productname     = $("form[name=checkoutform] select[name=productname]").val();
		var producttype     = $("form[name=checkoutform] select[name=producttype]").val();
		var productlocation = $("form[name=checkoutform] select[name=productlocation]").val();
		
		var checkoutamount  = $("form[name=checkoutform] input[name=checkoutamount]").val();
		    checkoutamount  = parseInt(checkoutamount);
		var remainamount    = $("form[name=checkoutform] input[name=remainamount]").val();
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
				
				getproductinfo();
				dialog_open(json);

			}
		});
	});
	
	
});

</script>

</html>
