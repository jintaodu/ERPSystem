<%@ page language="java" import="java.util.*" import="org.erpsystem.dao.*" import="java.sql.*" pageEncoding="UTF-8"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>

<head> 
   <title>My JSP 'warehousehistorybrowsing.jsp' starting page</title>
   
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">    
<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
<meta http-equiv="description" content="This is my page">

<jsp:include  page="/common/head.jsp"></jsp:include>

</head>
  
<body>
   
   <div class="col-md-12">
       <div class="page-header"><h4>选择查询条件</h4></div>
    	<!-- <button name="print" id="print" class="btn btn-primary">打印</button> -->
    	
    <form name="historybrowseform" method=POST >
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
		<input type="hidden" name="browsetype" value="historytable"></input>
		<button name="submit2" id="search" type="button" class="btn btn-primary">查询</button>
	</form>
	
	<div class="page-header"><h4>仓库历史记录</h4></div>
    	
    	<div class="col-md-12">
	        <table id="historytable" class="datatable display">
	    	<thead>
	               <tr>
	                   <th>货物名</th>
	                   <th>货物类型</th>
	                   <th>货物位置</th>
	                   <th>发生时间</th>
	                   <th>操作</th>
	               </tr>
	         </thead>
	         </table>
       </div>

	</div>
   
  </body>
  
  <script type="text/javascript">

  $('#producttypepicker').selectpicker();
  $('#productlocationpicker').selectpicker();
	
  //var productinfo = null;
  var table = $('#historytable').DataTable({
	  "aLengthMenu": [5, 10, 20, 50, 100],
	  "oLanguage": {		//汉化
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
  
/* 	function productnamepicker_change(){

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
} */
  
  function product_transaction_render( serializeArray )
  {   //获取仓库的库存信息
	  $.ajax({
		  url: "/ERPSystem/warehouse/productbrowseServlet",
			data:serializeArray,
			type: "get",
			async: false,
			dataType: 'json',
			error: function(xhr, message, obj) {
				
		        console.log("ERR:",xhr.responseText, message, obj);	
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
	  
	  	getproductinfo();
	  	product_select_change_interaction();
		//以下完成checkout form的动作绑定
		//货物名下拉列表改变事件
		/* $('select#productnamepicker').change(function(){
		
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
			
		}); */
		
		$('button#search').click(function(){
			
			var selectedprotuctname     = $("select#productnamepicker").val();
			var selectedproducttype     = $('select#producttypepicker').val();
			var selectedproductlocation = $('select#productlocationpicker').val();
			
			var serializeArray = $("form[name=historybrowseform]").serialize();
			
			product_transaction_render( serializeArray );

		});
		
	  

	 /*  $("button#print").click(function(){
		  window.print();
	  }); */

	
  });
  </script>
  
</html>


