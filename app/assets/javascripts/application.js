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
//= require_tree ./sessions

function reloadSocialMediaButtons()
{
  // For why we have to reload see: http://stackoverflow.com/questions/8565801/how-can-i-get-twitter-facebook-google-buttons-to-show-up-after-loading-page
  
  // Reload the facebook button (http://developers.facebook.com/docs/reference/javascript/FB.XFBML.parse/)
  FB.XFBML.parse();

  // Reload the twitter button (https://dev.twitter.com/discussions/890)
  twttr.widgets.load();
}

function enableButtons()
{
  var next = $(".current_snop").next();
  var prev = $(".current_snop").prev();

  $('#next').attr("disabled", next.attr("id") === undefined);
  $('#prev').attr("disabled", prev.attr("id") === undefined);
}

function changeToListView()
{
  $("#snops_list_view").show();
  $("#snops_browse_view").hide();
}

function changeToBrowseView()
{
  $("#snops_list_view").hide();
  $("#snops_browse_view").show();
}

function reloadClickHandlers()
{
  enableButtons();

  // Click handler for the previous button in browse view
  $("#prev").click(function() 
  {
    var prev_snop = $(".current_snop").prev();
    var current_snop = $(".current_snop");
    current_snop.removeClass("current_snop");
    current_snop.addClass("hidden_snops");
    prev_snop.removeClass("hidden_snops");
    prev_snop.addClass("current_snop");
    $(prev_snop).css({'margin-left':'-200%'}).animate({'margin-left':'0'});
    reloadSocialMediaButtons();  
    enableButtons();
  });

  // Click handler for the next button in browse view
  $("#next").click(function() {
    var next_snop = $(".current_snop").next();
    var current_snop = $(".current_snop");
    current_snop.removeClass("current_snop");
    current_snop.addClass("hidden_snops");
    next_snop.removeClass("hidden_snops");
    next_snop.addClass("current_snop");
    $(next_snop).css({'margin-left':'100%'}).animate({'margin-left':'0'});  
    reloadSocialMediaButtons();  
    enableButtons();
  });
}

$(document).ready(function() 
{
  reloadClickHandlers();
});