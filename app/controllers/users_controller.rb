class UsersController < ApplicationController
  include UserHelper

  # GET /users/:id
  def show
    # Get the user specified
    @user = User.find(params[:id])

    # Check if a direction is passed in (For JS animation)
    @direction = params[:direction].to_s if params[:direction]

    # Get all the snops for our user
    @snops = get_all_snops_for_user(@user)
    @snops.to_a

    # Default to the first snop
    @snop = @all_snops.first if @all_snops

    # If one was passed in we'll use that one
    @snop = Snop.find(params[:snop]) if params[:snop] && Snop.exists?(params[:snop])

    # Set the showing snop in the session
    session[:showing_snop_id] = @snop.id unless @snop.nil?
  end
end
