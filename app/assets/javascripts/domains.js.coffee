# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# Hide the browse view until the user request it.
jQuery -> 
  $('#resources').dataTable( {
    "bFilter": true, 
    "oLanguage": { "sSearch": "Filter:" }
    "bJQueryUI": true,
    "aaSorting": [],
    "bProcessing": true,
    "bServerSide": true,
    "sAjaxSource": $("#resources").data("source")
    });