# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery -> 
  # Hide the browse view until the user request it.
  $("#snops_browse_view").hide();

  # Create the datatable
  $('#snops').dataTable( {
    "bFilter": true, 
    "oLanguage": { "sSearch": "Filter:" }
    "bJQueryUI": true,
    "aaSorting": [],
    "bProcessing": true,
    "bServerSide": true,
    "sAjaxSource": $("#snops").data("source")
    });  

  # Click handler for the Remove button on the user page
  $("#RemoveButton").click(() ->
    # Make the user confirm First
    if (!confirm("You will permanently delete any selected snops that are yours and Unfavourite any snops that are not yours. Are you sure you want to do this?"))
      return false

    # For each selected row, we delete or unfave it
    $(".row_selected").each( (index) ->    
      $(this).removeClass(".row_selected");

      # We currently have no way to know... if the snop
      # is the current users snop or not... that is all
      # stored on the server side... so...
      # First try deleting
      $.ajax({
        type: "DELETE",
        url: "/snops/" + $(this).attr("id"),
        dataType: "script"
        });

      # Then try unfavouriting
      $.ajax({
        type: "POST",
        url: "/fave_snops/unfavourite",
        data: { snop: $(this).attr("id") },
        dataType: "script"
        });
    );

    # Make sure remove button is disabled now.
    $("#RemoveButton").attr("disabled", "disabled");
  );

  # Click handler for when a row in the users table is clicked
  $(document).on("click", "#snops tbody tr", (e) ->
    # If the row has a valid ID, we select it (toggle)
    $(this).toggleClass('row_selected') if $(this).attr("id")

    # If we have at least 1 row selected, we can enable the remove button
    if $(".row_selected").size() > 0
      $("#RemoveButton").removeAttr("disabled");
    else
      $("#RemoveButton").attr("disabled", "disabled");
  );

  # A click handler for when the categories drop down is clicked, 
  # allows us to ignore selecting the row as well (stop progagation to parent)
  $(document).on("click", "#snops tbody tr select", (e) ->
    e.stopPropagation();
  );
