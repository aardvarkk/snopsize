class UsersController < ApplicationController

  # GET /users/:id
  def show
    # Get the user specified
    @user = User.find(params[:id])

    # Check if a direction is passed in (For JS animation)
    @direction = params[:direction].to_s if params[:direction]

    # Get a list of all the users created snop ids
    # (i.e. snops created by the user)
    user_snops = @user.snops.where(deleted: false)

    # Get the list of favourte snop ids
    fave_snops = @user.favourites
    
    # Combine them
    # Note that we check this value in testing
    # We want to make sure there are no duplicates within it
    # This could happen if you favourited your own snop
    @all_snops = (user_snops + fave_snops).uniq
    
    # Get all categorized snops
    categorized_snops = @user.categorized_snops
    
    # Get all uncategorized snops, and make sure we only
    # get unique ones.
    @uncategorized_snops = @all_snops - categorized_snops
    
    # Find a set of "root" categories
    @root_categories = @user.user_categories.where("parent_id IS ?", nil)

    # Default to the first snop
    @snop = @all_snops.first

    # If one was passed in we'll use that one
    @snop = Snop.find(params[:snop]) if params[:snop] && Snop.exists?(params[:snop])

    # Now we'll set the next and previous
    snop_index = @all_snops.index(@snop)

    # Set the previous
    @prev = @all_snops[snop_index - 1] if snop_index > 0

    # Set the next
    @next = @all_snops[snop_index + 1] if snop_index < @all_snops.size - 1

    # Respond with the appropriate data
    respond_to do |format|
      format.html #show.html.erb
      format.js   #show.js.erb
    end
  end
end
