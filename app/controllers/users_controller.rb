class UsersController < ApplicationController

  # GET /users/:id
  def show
  	@user = User.find(params[:id])
  	
  	# Get a list of all the users created snops
  	# (i.e. snops created by the user)
  	@user_snops = @user.snops

    # Get the list of favourtes
    @fave_snops = @user.favourites
  end
end
