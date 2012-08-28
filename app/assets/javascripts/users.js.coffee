# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

//= require application

# Hide the browse view until the user request it.
jQuery -> 
  $("#snops_browse_view").hide();
  $('#snops').dataTable( {
    "bFilter": false, 
    "bJQueryUI": true,
    "aaSorting": [],
    "bProcessing": true,
    "bServerSide": true,
    "sAjaxSource": $("#snops").data("source"),
    "aoColumns": [
        null,
        null,
        null,
        null,
        null,
        {"bSortable": false}
        ]
    });
