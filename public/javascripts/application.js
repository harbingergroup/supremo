// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(document).ready(function(){
     $(".all_notice").hide();
    $("#notice").slideDown("slow");
    $("#notice").setHovers();
    setTimeout(function(){
        $("#notice").hideNotice();
    },3000);
})


$(document).ready(function(){
    $(".tablesorter").tablesorter(
    {
        widthFixed: true,
        headers: {
            5:{
                sorter : false
            }
        }
    });
//.tablesorterPager({container: $("#pager"),size: 20,positionFixed: false});
//tablesorter();
//$(".tablesorter").tableHover();
})
$(document).ready(function(){
    $("td").hover(
        function(){
            $(this).parent("tr").addClass("hover");
        },
        function(){
            $(this).parent("tr").removeClass("hover");
        }
        )

    jQuery.fn.hideAfter = function(time){
        setTimeout(hide_this,time,$(this));
    }
    function hide_this(obj) {
        obj.hide();
    }

})

jQuery.fn.hideNotice = function(){
    if($(this).hasClass("hovered")){
        // setTimeout(function(){$(this).hideNotice();},500);  // Or
       $(this).addClass("aghovered")
    }
    else{
        $(this).slideUp();
    }
}
jQuery.fn.setHovers= function(){
    $(this).hover(
        function(){
            $(this).addClass('hovered');
        },
        function(){
             if ($(this).hasClass("aghovered")){$(this).slideUp();}
            else{
            $(this).removeClass('hovered');
        }
        }
        );
}


function set_notice(notice){
    $(".all_notice").hide();
    $(".j_notice").html(notice).slideDown("slow");
    $(".j_notice").setHovers()
    setTimeout(function(){
        $(".j_notice").hideNotice();
    },3000);
}

function set_alert(notice){
    $(".all_notice").hide();
    $(".j_alert").html(notice).slideDown("slow");
    $(".j_alert").setHovers()
    setTimeout(function(){
        $(".j_alert").hideNotice();
    },3000);
}

$(function() {
		$( "#accordion" ).accordion({
			collapsible: true
		});
});

/*************accordian**************/
$(document).ready(function() {
       $("#accordion").accordion({ active: false});
});


/************Login Page dialog*********/
$.fx.speeds._default = 1100;
	$(function() {
		$( "#dialog" ).dialog({
			autoOpen: false,
			show: "slide",
			modal: true,
			title: "Login",
			hide: "clip",
			
		});

		$( "#login_link" ).click(function() {
			$( "#dialog" ).dialog("open");
			return false;
		});
});

/***************Comments dialog****************/
$.fx.speeds._default = 1100;
	$(function() {
		$( "#new_comment" ).dialog({
			autoOpen: false,
			show: "slide",
			modal: true,
			title: "Add your comment",
			hide: "clip",
			width: 428,
			height: 375
			
		});

		$( "#comment_link" ).click(function() {
			$( "#new_comment" ).dialog("open");
			return false;
		});
});