class UsersController < ApplicationController
  include UserHelper

  # GET /users/:id
  def show
    # Get the user specified
    @user = User.find(params[:id])

    # Check if a direction is passed in (For JS animation)
    @direction = params[:direction].to_s if params[:direction]

    # Get all the snops for our user
    @all_snops = get_all_snops_for_user(@user)

    # Default to the first snop
    @snop = @all_snops.first if @all_snops

    # If one was passed in we'll use that one
    @snop = Snop.find(params[:snop]) if params[:snop] && Snop.exists?(params[:snop])

    # Respond with the appropriate data
    respond_to do |format|
      format.html #show.html.erb
      format.js   #show.js.erb
    end
  end
end
