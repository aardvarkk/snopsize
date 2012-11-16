# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# Set up the dataTable
jQuery -> 
  $('#snops').dataTable( {
    "bFilter": true, 
    "oLanguage": { "sSearch": "Filter:" }
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
        {"bVisible": false}
        ]
    });
