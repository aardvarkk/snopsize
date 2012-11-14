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

// Function to reload the AJAX source for the datatable, useful for when you want to switch the 
// data source. 
// See documentation here: http://datatables.net/plug-ins/api
$.fn.dataTableExt.oApi.fnReloadAjax = function ( oSettings, sNewSource, fnCallback, bStandingRedraw )
{
    if ( typeof sNewSource != 'undefined' && sNewSource != null ) {
        oSettings.sAjaxSource = sNewSource;
    }
 
    // Server-side processing should just call fnDraw
    if ( oSettings.oFeatures.bServerSide ) {
        this.fnDraw();
        return;
    }
 
    this.oApi._fnProcessingDisplay( oSettings, true );
    var that = this;
    var iStart = oSettings._iDisplayStart;
    var aData = [];
  
    this.oApi._fnServerParams( oSettings, aData );
      
    oSettings.fnServerData.call( oSettings.oInstance, oSettings.sAjaxSource, aData, function(json) {
        /* Clear the old information from the table */
        that.oApi._fnClearTable( oSettings );
          
        /* Got the data - add it to the table */
        var aData =  (oSettings.sAjaxDataProp !== "") ?
            that.oApi._fnGetObjectDataFn( oSettings.sAjaxDataProp )( json ) : json;
          
        for ( var i=0 ; i<aData.length ; i++ )
        {
            that.oApi._fnAddData( oSettings, aData[i] );
        }
          
        oSettings.aiDisplay = oSettings.aiDisplayMaster.slice();
          
        if ( typeof bStandingRedraw != 'undefined' && bStandingRedraw === true )
        {
            oSettings._iDisplayStart = iStart;
            that.fnDraw( false );
        }
        else
        {
            that.fnDraw();
        }
          
        that.oApi._fnProcessingDisplay( oSettings, false );
          
        /* Callback user function - for event handlers etc */
        if ( typeof fnCallback == 'function' && fnCallback != null )
        {
            fnCallback( oSettings );
        }
    }, oSettings );
};

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
  // Show the corresponding view
  $(".snops_list_view").show();
  $("#snops_browse_view").hide();

  // Switch the flow/list button states
  $(".snopflow").addClass(".snopflow off");
  $(".snopflow off").removeClass(".snopflow");
  $(".listview off").addClass(".listview");
  $(".listview").removeClass(".listview off");

  // Set visibility of next/prev buttons
  $('#prev').css("visibility", "hidden");
  $("#next").css("visibility", "hidden");
}

function changeToBrowseView()
{
  // Show the corresponding view
  $(".snops_list_view").hide();
  $("#snops_browse_view").show();

  // Switch the flow/list button states
  $(".listview").addClass(".listview off");
  $(".listview off").removeClass(".listview");
  $(".snopflow off").addClass(".snopflow");
  $(".snopflow").removeClass(".snopflow off");

  // Set visibility of next/prev buttons
  $('#prev').css("visibility", "visible");
  $("#next").css("visibility", "visible");
}

function reloadClickHandlers()
{
  // Assume nothing is clickable
  $('#prev').off('click')
  $('#next').off('click')

  // Check if there's somewhere to go, and if so,
  // then enable a click handler
  var prev = $(".current_snop").prev();
  var next = $(".current_snop").next();

  // Should this button be disabled?
  if (prev.attr("id") !== undefined) {
    $("#prev").on('click', function() 
    {
      var prev_snop = $(".current_snop").prev();
      var current_snop = $(".current_snop");
      current_snop.removeClass("current_snop");
      current_snop.addClass("hidden_snops");
      prev_snop.removeClass("hidden_snops");
      prev_snop.addClass("current_snop");
      $(prev_snop).css({'margin-left':'-200%'}).animate({'margin-left':'0'});
      reloadSocialMediaButtons();  
      reloadClickHandlers();
    });    
  }
  
  // Should this button be disabled?
  if (next.attr("id") !== undefined) {
      $("#next").on('click', function() {
      var next_snop = $(".current_snop").next();
      var current_snop = $(".current_snop");
      current_snop.removeClass("current_snop");
      current_snop.addClass("hidden_snops");
      next_snop.removeClass("hidden_snops");
      next_snop.addClass("current_snop");
      $(next_snop).css({'margin-left':'100%'}).animate({'margin-left':'0'});  
      reloadSocialMediaButtons();  
      reloadClickHandlers();
    });
  }
}

$(document).ready(function() 
{
  reloadClickHandlers();
});