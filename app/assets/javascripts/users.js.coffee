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

  # Click handler for the Delete button on the user page
  $("#DeleteButton").click(() ->
    
    # Make the user confirm First
    if (!confirm("Are you sure you wish to delete these snops?"))
      return false

    # For each selected row, we delete it
    $(".row_selected").each( (index) ->    
      $(this).removeClass(".row_selected");

      # Delete
      $.ajax({
        type: "DELETE",
        url: "/snops/" + $(this).attr("id"),
        dataType: "script"
        });
    );

    # Make sure remove button is disabled now.
    $("#DeleteButton").attr("disabled", "disabled");
    $("#CategoriesSelect").attr("disabled", "disabled");
  );

  # Change handler for the select box for mass categorization
  $("#CategoriesSelect").change(() ->

    # Make the user confirm First
    if (!confirm("Are you sure you wish to categorize these snops?"))
      return false

    id = ""
    id += $(this).val()

    # For each selected row, we categorize it accordingly    
    $(".row_selected").each( (index) ->   
      $(this).removeClass(".row_selected"); 
      $.ajax({
        type: "POST",
        url: "/user_categories/set_snop?snop=" + $(this).attr("id"),
        data: {
          "user_category": {"id":id}
        },
        dataType: "script"
        });
    );

    # redraw the table now
    datatable = $("#snops").dataTable();
    datatable.fnDraw();

    # disable the button
    $("#CategoriesSelect").attr("disabled", "disabled");
    $("#DeleteButton").attr("disabled", "disabled");
    $("#UnfavouriteButton").attr("disabled", "disabled");
  );

  # Click handler for the Unfavourite button on the user favourites page
  $("#UnfavouriteButton").click(() ->
    
    # Make the user confirm First
    if (!confirm("Are you sure you wish to unfavourite these snops?"))
      return false

    # For each selected row, we unfave it
    $(".row_selected").each( (index) ->    
      $(this).removeClass(".row_selected");

      # Unfavourite
      $.ajax({
        type: "POST",
        url: "/fave_snops/unfavourite",
        data: { snop: $(this).attr("id") },
        dataType: "script"
        });
    );

    # Make sure remove button is disabled now.
    $("#UnfavouriteButton").attr("disabled", "disabled");
    $("#CategoriesSelect").attr("disabled", "disabled");
  );

  # Click handler for when a row in the users table is clicked
  $(document).on("click", "#snops tbody tr", (e) ->
    # If the row has a valid ID, we select it (toggle)
    $(this).toggleClass('row_selected') if $(this).attr("id")

    # If we have at least 1 row selected, we can enable the delete/unfavourite buttons
    if $(".row_selected").size() > 0
      $("#DeleteButton").removeAttr("disabled");
      $("#UnfavouriteButton").removeAttr("disabled");
      $("#CategoriesSelect").removeAttr("disabled");
    else
      $("#DeleteButton").attr("disabled", "disabled");
      $("#UnfavouriteButton").attr("disabled", "disabled");
      $("#CategoriesSelect").attr("disabled", "disabled");
  );

  # A click handler for when the categories drop down is clicked, 
  # allows us to ignore selecting the row as well (stop progagation to parent)
  $(document).on("click", "#snops tbody tr select", (e) ->
    e.stopPropagation();
  );
