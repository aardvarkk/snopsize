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
  // alert('Changing to list view...')

  // Show anything in the snops list view class
  $(".snops_list_view").show();

  // Hide our browse view
  $("#snops_browse_view").hide();

  // show the snop flow button as not highlighted anymore (not selected)
  $(".snopflow").addClass(".snopflow off");
  $(".snopflow.off").removeClass(".snopflow");

  // show the list view button as highlighted (selected)
  $(".listview.off").addClass(".listview");
  $(".listview").removeClass(".listview off");

  // hide the nav buttons in list view
  $(".tools.short").hide();

  // set container to have no padding
  $(".container").css("padding", "0px");

  // hide everything in the side nav
  // alert('Hiding all sidenavs...')
  $(".sidenav").hide();
}

function changeToBrowseView()
{
  // alert('Changing to browse view...')

  // Hide anything in the snops list view class
  $(".snops_list_view").hide();

  // Show our browse view
  $("#snops_browse_view").show();

  // show the list view button as not highlighted anymore (not selected)
  $(".listview").addClass(".listview off");
  $(".listview.off").removeClass(".listview");

  // show the snop flow button as highlighted (selected)
  $(".snopflow.off").addClass(".snopflow");
  $(".snopflow").removeClass(".snopflow off");

  // Show the nav buttons
  $(".tools.short").show();

  // change container to have a padding
  $(".container").css("padding", "25px");

  // show the current snop in the side nav
  // alert('Showing only current sidenav...')
  $(".sidenav").hide();
  $(".sidenav#current").show();

  // we need to recalculate snop container width in brose view
  reloadRecalculateSnopContainerWidth();
}

function prevSnop()
{
  // Deal with the side nav
  var curr_sidenav = $(".sidenav#current");
  var prev_sidenav = curr_sidenav.prev();
  curr_sidenav.removeAttr('id');
  prev_sidenav.attr('id', 'current');
  curr_sidenav.hide();
  prev_sidenav.show();

  // Get the previous snop and make it the current.
  // The current will now be hidden.
  var prev_snop = $(".current_snop").prev();
  var current_snop = $(".current_snop");
  current_snop.removeClass("current_snop");
  current_snop.addClass("hidden_snops");
  prev_snop.removeClass("hidden_snops");
  prev_snop.addClass("current_snop");

  // pan the snop container to the previous snop
  $("#snop_container").animate({left: '+=' + snop_width});

  reloadSocialMediaButtons();  
  reloadClickHandlers();
}

function nextSnop()
{
  // Deal with the side nav
  var curr_sidenav = $(".sidenav#current");
  var next_sidenav = curr_sidenav.next();
  curr_sidenav.removeAttr('id');
  next_sidenav.attr('id', 'current');
  curr_sidenav.hide();
  next_sidenav.show();

  // Get the next snop and make it the current.
  // The current will now be hidden.
  var next_snop = $(".current_snop").next();
  var current_snop = $(".current_snop");
  current_snop.removeClass("current_snop");
  current_snop.addClass("hidden_snops");
  next_snop.removeClass("hidden_snops");
  next_snop.addClass("current_snop");

  // pan the snop container to the next snop
  $("#snop_container").animate({left: '-=' + snop_width});

  reloadSocialMediaButtons();  
  reloadClickHandlers();
}

function reloadRecalculateSnopContainerWidth()
{
  // here we will just make sure we set the width of the snop container
  // properly based on the number of snops that are displayed on the page
  if (num_snops)
  {
    $("#snop_container").css("width", snop_width * num_snops);
  }
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

  // Should the prev button be disabled?
  if (prev.attr("id") !== undefined) {
    $("#prev").on('click', prevSnop)
  }
  
  // Should the next button be disabled?
  if (next.attr("id") !== undefined) {
      $("#next").on('click', nextSnop)
  }
}

// Called when the document loads
$(document).ready(function() 
{
  reloadClickHandlers();
  reloadRecalculateSnopContainerWidth();
});
