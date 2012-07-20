class UsersController < ApplicationController

  # GET /users/:id
  def show
  	@user = User.find(params[:id])
  	@fave_snops = FaveSnops.where(["user_id = ?", @user.id]).all
  	@snops = Array.new
  	@fave_snops.each do |fave_snop|
  	  snop = Snop.find(fave_snop.snop_id)
  	  @snops << snop  
  	end
  end
end
