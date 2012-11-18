# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# Set up the dataTable
jQuery -> 
  $('#snops').dataTable( {
    "bFilter": true, 
    "oLanguage": { "sSearch": "Filter:", "oPaginate" : { "sNext": "", "sPrevious": "" } },
    "aaSorting": [],
    "bProcessing": true,
    "bServerSide": true,
    "sAjaxSource": $("#snops").data("source"),
    "aoColumns": [
        { "sClass": "snop_title" },
        { "sWidth": "75px" },
        { "sWidth": "200px" },
        { "sWidth": "100px" },
        { "bVisible": false }
        ]
    });

  reloadClickHandlers();