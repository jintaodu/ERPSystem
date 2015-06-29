/*
 * author: dujintao
 * contact: dujintaocs@gmail.com
 * description: This javascript file contains the definition of commonly used functions
 * 
 */


//jquery-UI 对话框调用函数

function dialog_open(json){
	
	$( "#dialog p" ).text( json.result );

	$( "#dialog" ).dialog({
	    autoOpen: false,
	    title:json.title,
	    position: [200,200],
	    buttons: {
	        "确认": function () {
	            $(this).dialog("close");
	        }
	    }
	    
	  });
	
	$("#dialog").dialog( "open" );
}

//选择货物名称、型号、储存地的处理与前端交互

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

function product_select_change_interaction(){
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
}






