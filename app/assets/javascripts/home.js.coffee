# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery -> 
  
    $('#snops').dataTable( {
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
        { "sWidth": "75px" },
        null,
        { "sWidth": "100px" },
        { "bVisible": false }
        ]
    })

    # Initial setup of the page
    # Occurs after everything has loaded to set up active buttons, etc.
    # alert 'Setting up the page...'
    if browseView
        # alert 'Calling changeToBrowseView...'
        changeToBrowseView()
    else
        # alert 'Calling changeToListView...'
        changeToListView()
    end