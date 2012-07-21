class FaveSnopsController < ApplicationController
  before_filter :authenticate_user!
	
  #POST /fave_snops/favourite
  def favourite
  	# Add a new fave snop entry
  	user = current_user
  	@snop = Snop.find(params[:snop])
  	fave_snop = FaveSnop.new
  	fave_snop.user_id = user.id
  	fave_snop.snop_id = @snop.id
  	fave_snop.save
  	
    respond_to do |format|
      format.js
    end
  end

  #POST /fave_snops/unfavourite
  def unfavourite
  	# Find the fave snop entry and delete it
  	user = current_user
  	@snop = Snop.find(params[:snop])
  	fave_snop = FaveSnop.where(["user_id = ? AND snop_id = ?", user.id, @snop.id]).first
  	fave_snop.destroy unless fave_snop.nil?
  	
  	respond_to do |format|
      format.js
    end
  end
end
