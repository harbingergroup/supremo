// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults


$(document).ready(function(){

    $('.ticket_action').live("click",function() {

        $( "#ticket_comment_form" ).dialog({
        autoOpen: false,
        title: "Comment",
        width: 450,
        modal: true

    });
        $(".tc_form").attr('action',$(this).attr('href'));
        $( "#ticket_comment_form" ).dialog('open');
        return false;
    });
})


$(document).ready(function(){
    $(".all_notice").hide();
    $("#notice, #alert").slideDown("slow");
    $("#notice,#alert").setHovers();
    setTimeout(function(){
        $("#notice,#alert").hideNotice();
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
            if ($(this).hasClass("aghovered")){
                $(this).slideUp();
            }
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
			collapsible: true,
			autoHeight: false
		});
});

$(function() {
		$( "#tickets_accordion" ).accordion({
			collapsible: true,
			autoHeight: false				
		});
});


/************Login Page dialog*********/
/*$.fx.speeds._default = 1100;
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
});*/

/***************Comments dialog****************/
$.fx.speeds._default = 1100;
	$(function() {

            $( "#comment_link" ).click(function() {
		$( "#new_comment" ).dialog({
			autoOpen: false,
			show: "slide",
			modal: true,
			title: "Add your comment",
			width: 428,
			height: 375
			
		});

		
			$( "#new_comment" ).dialog("open");
			return false;
		});
});

/***************Image Upload dialog****************/
$.fx.speeds._default = 1100;
	$(function() {
		$( "#upload_profile_pic" ).dialog({
			autoOpen: false,
			show: "slide",
			modal: true,
			title: "Upload Profile Picture",
			hide: "clip"
			//width: 428,
			//height: 375
			
		});

		$( "#upload_image_link" ).click(function() {
			$( "#upload_profile_pic" ).dialog("open");
			return false;
		});
});

  $(document).ready(function() {
   
    $(".tc_form")
      .bind('ajax:before', show_throbber)
      //.bind('ajax:success', function(data, status, xhr) {alert("success!");})
     // .bind('ajax:failure', function(xhr, status, error) {alert("failure!");})
      .bind('ajax:complete', hide_throbber);
  });


function show_throbber() {
  $(".tcSubmit").hide();
  $(".aThrobber").show();
}

function hide_throbber() {
    $(".aThrobber").hide();
    $(".tcSubmit").show();
}

/*
$(document).ready(function() {

$('.ulName').click(function()
{
$(this).qtip({
   content: {
      text: 'Loading...', // The text to use whilst the AJAX request is loading
      ajax: {
         url: $(this).attr("href")+'.js', // URL to the local file
         type: 'GET', // POST or GET
         data: {} // Data to pass along with your request
      }
   }
});

return false;
})

})*/
