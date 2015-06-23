/*
 * author: dujintao
 * contact: dujintaocs@gmail.com
 * description: This javascript file contains the common user-defined functions
 * 
 */

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