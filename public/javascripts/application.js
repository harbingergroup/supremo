// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(document).ready(function(){
    // $("#users_table,#tt_in_admin,#ptable_in_admin").tablesorter();
    //$("#users_table,#tt_in_admin,#ptable_in_admin").tableHover({colClass: 'hover'});
    //$("#users_table,#tt_in_admin,#ptable_in_admin").tableHover();
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