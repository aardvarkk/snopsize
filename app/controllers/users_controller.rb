class UsersController < ApplicationController

  # GET /users/:id
  def show

    @user = User.find(params[:id])
    
    # Get a list of all the users created snop ids
    # (i.e. snops created by the user)
    user_snops = @user.snops.where(:deleted => false)

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

  end
end
