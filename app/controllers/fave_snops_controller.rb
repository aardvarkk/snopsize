class FaveSnopsController < ApplicationController
  before_filter :authenticate_user!
	
  #POST /fave_snops/favourite
  def favourite
  	# Add a new fave snop entry
  	@snop = Snop.find(params[:snop])
    current_user.favourites << @snop
  	
    respond_to do |format|
      format.js
    end
  end

  #POST /fave_snops/unfavourite
  def unfavourite
  	# Find the fave snop entry and delete it
  	@snop = Snop.find(params[:snop])
  	current_user.favourites.destroy(@snop)
  	
  	respond_to do |format|
      format.js
    end
  end
end
