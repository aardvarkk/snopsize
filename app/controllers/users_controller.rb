class UsersController < ApplicationController

  # GET /users/:id
  def show
  	@user = User.find(params[:id])
  	
  	# Get a list of all the users created snop ids
  	# (i.e. snops created by the user)
  	user_snop_ids = @user.snop_ids

    # Get the list of favourte snop ids
    fave_snop_ids = @user.favourite_ids
    
    # Combine them
    all_snop_ids = user_snop_ids + fave_snop_ids
    
    # Get the snops for those ids
    all_snops = Snop.find(all_snop_ids)
    
	  # Get all categorized snops
		categorized_snops = @user.categorized_snops
		
		# Get all uncategorized snops, and make sure we only
		# get unique ones.
		@uncategorized_snops = all_snops - categorized_snops
		
		# Find a set of "root" categories
		@root_categories = @user.user_categories.where("parent_id IS ?", nil)
	  end
end
