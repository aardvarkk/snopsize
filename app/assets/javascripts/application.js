// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require dataTables/jquery.dataTables

// The size of the "container" div is 800px, but it has 25 px padding, therefore the width of a 
// snop in browse view is 750px. We add a 25px padding to the right side so that the snops aren't
// touching each other. That's how we come up with 775px
var snop_width = 775;

function reloadSocialMediaButtons()
{
  // For why we have to reload see: http://stackoverflow.com/questions/8565801/how-can-i-get-twitter-facebook-google-buttons-to-show-up-after-loading-page
  
  // Reload the facebook button (http://developers.facebook.com/docs/reference/javascript/FB.XFBML.parse/)
  FB.XFBML.parse();

  // Reload the twitter button (https://dev.twitter.com/discussions/890)
  twttr.widgets.load();
}

function changeToListView()
{
  // alert('Changing to list view...')

  // Hide the notice
  $("#notice").hide();

  // Show anything in the snops list view class
  $("#snops_list_view").show();

  // Hide our browse view
  $("#snops_browse_view").hide();

  // show the snop flow button as not highlighted anymore (not selected)
  //(".snopflow").addClass(".snopflow off");
  //$(".snopflow.off").removeClass(".snopflow");

  // show the list view button as highlighted (selected)
  //$(".listview.off").addClass(".listview");
  //$(".listview").removeClass(".listview off");

  // hide the nav buttons in list view
  $(".tools.short").hide();

  // set container to be list view style -- no padding for the table
  $(".container").addClass("list_view");

  // hide the browse view side nav, show the
  // tools sidenav
  $(".sidenav_container").hide();
  $(".sidenav_container.tools").show();
}

function changeToBrowseView(id)
{
  // alert('Changing to browse view...')

  // Hide the notice
  $("#notice").hide();

  // Hide anything in the snops list view class
  $("#snops_list_view").hide();

  // Show our browse view
  $("#snops_browse_view").show();

  // show the list view button as not highlighted anymore (not selected)
  //$(".listview").addClass(".listview off");
  //$(".listview.off").removeClass(".listview");

  // show the snop flow button as highlighted (selected)
  //$(".snopflow.off").addClass(".snopflow");
  //$(".snopflow").removeClass(".snopflow off");

  // Show the nav buttons
  $(".tools.short").show();

  // change container to have a padding (it's now just a normal container)
  $(".container").removeClass("list_view");

  // show the current snop in the side nav
  $(".sidenav_container").hide();
  $(".sidenav_container.flow").show();

  // if they passed in an id
  if (id != undefined && id != "") {
    setCurrentSnop(id);
  }
}

function setCurrentSnop(id)
{
  // alert(new Error().stack);

  // show the right side nav
  var curr_sidenav = $(".sidenav.current");
  curr_sidenav.removeClass('current');
  curr_sidenav.addClass('hidden');
  var new_sidenav = $("#" + id);
  new_sidenav.removeClass("hidden");
  new_sidenav.addClass("current");  
  curr_sidenav.hide();
  new_sidenav.show();

  // show the right snop
  var curr_snopflow = $(".snop.current");
  curr_snopflow.removeClass("current");
  curr_snopflow.addClass("hidden");
  var to_show = $("#snop_" + id);
  to_show.removeClass("hidden");
  to_show.addClass("current");

  // we need to calculate the index of the snop in
  // the list of divs
  var idx = to_show.prevAll().length;

  // now we need to find the left offset so we can pan
  // correctly
  var offset = idx * -snop_width;
  $("#snop_container").css("left", offset);

  // do a quick highlight effect to show the change!?
  $(".container").effect("highlight", {}, 1000);
  to_show.effect("highlight", {}, 1000);
}

function prevSnop()
{
  // Deal with the side nav
  var curr_sidenav = $(".sidenav.current");
  var prev_sidenav = curr_sidenav.prev();
  curr_sidenav.removeClass('current');
  curr_sidenav.addClass('hidden');
  prev_sidenav.addClass('current');
  prev_sidenav.removeClass('hidden');
  curr_sidenav.hide();
  prev_sidenav.show();

  // Get the previous snop and make it the current.
  // The current will now be hidden.
  var prev_snop = $(".snop.current").prev();
  var current_snop = $(".snop.current");
  current_snop.removeClass("current");
  current_snop.addClass("hidden");
  prev_snop.removeClass("hidden");
  prev_snop.addClass("current");

  // pan the snop container to the previous snop
  $("#snop_container").animate({left: '+=' + snop_width});

  reloadClickHandlers();
  //reloadSocialMediaButtons();  
}

function nextSnop()
{
  // Deal with the side nav
  var curr_sidenav = $(".sidenav.current");
  var next_sidenav = curr_sidenav.next();
  curr_sidenav.removeClass('current');
  curr_sidenav.addClass('hidden');
  next_sidenav.addClass('current');
  next_sidenav.removeClass('hidden');
  curr_sidenav.hide();
  next_sidenav.show();

  // Get the next snop and make it the current.
  // The current will now be hidden.
  var next_snop = $(".snop.current").next();
  var current_snop = $(".snop.current");
  current_snop.removeClass("current");
  current_snop.addClass("hidden");
  next_snop.removeClass("hidden");
  next_snop.addClass("current");

  // pan the snop container to the next snop
  $("#snop_container").animate({left: '-=' + snop_width});

  reloadClickHandlers();
  //reloadSocialMediaButtons();  
}

function reloadRecalculateSnopContainerWidth(num_snops)
{
  // Here we will just make sure we set the width of the snop container
  // properly based on the number of snops that are displayed on the page
  // alert('Setting snop container width')
  $("#snop_container").css("width", snop_width * num_snops);
}

function hasPrev()
{
  var prev = $(".snop.current").prev();
  if (prev.attr("id") == undefined)
  {
    return false;
  }
  else
  {
    return true;
  }
}

function hasNext()
{
  var next = $(".snop.current").next();
  if (next.attr("id") == undefined)
  {
    return false;
  }
  else
  {
    return true;
  }
}

function reloadClickHandlers()
{
  // Assume nothing is clickable
  $('#prev').off('click').addClass('disabled')
  $('#next').off('click').addClass('disabled')

  // Should the prev button be disabled?
  if (hasPrev()) {
    $("#prev").on('click', prevSnop).removeClass('disabled')
  }
  
  // Should the next button be disabled?
  if (hasNext()) {
    $("#next").on('click', nextSnop).removeClass('disabled')
  }
}

// Shows the select drop down with a custom icon
$(document).ready(function(){ 
    if (!$.browser.opera) {
        $('select.drop').each(function(){
            var title = $(this).attr('title');
            if( $('option:selected', this).val() != ''  ) title = $('option:selected',this).text();
            // Hack to give a title to Uncategorized category which has nil value
            if (title == undefined) { title = 'Uncategorized' }
            $(this)
                .css({'z-index':10,'opacity':0,'-khtml-appearance':'none'})
                .after('<span class="select">' + title + '</span>')
                .change(function(){
                    val = $('option:selected',this).text();
                    $(this).next().text(val);
                    })
        });
    };
});