# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery -> 
  
  $('#snops').dataTable( {
    "bJQueryUI": true,
    "bFilter": false, 
    "bLengthChange": false,
    "bPaginate": false,
    "bInfo": false,
    "bSort": false,
    "bProcessing": true,
    "bServerSide": true,
    "sAjaxSource": $("#snops").data("source")
    "aoColumns": [
        null,
        null,
        null,
        null,
        {"bVisible": false}
        ]
    });

  if browseView
    changeToBrowseView()
  else
    changeToListView()
  end

  