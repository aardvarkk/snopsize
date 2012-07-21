class UsersController < ApplicationController

  # GET /users/:id
  def show
  	@user = User.find(params[:id])
  	
  	# Get a list of all the users created snops
  	# (i.e. snops created by the user)
  	@usersnops = @user.snops
  	
  	# Get a list of the users favourite snops
  	@fave_snops = @user.fave_snops
  	@snops = Array.new
  	@fave_snops.each do |fave_snop|
  	  @snops << fave_snop.snop  
  	end
  end
end
