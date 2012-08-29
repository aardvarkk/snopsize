class FaveSnopsController < ApplicationController
  include ApplicationHelper
  include FaveSnopsHelper
  include UserHelper

  before_filter :authenticate_user!
	
  #POST /fave_snops/favourite
  def favourite
  	
    # Add a new fave snop entry
  	@snop = Snop.find(params[:snop])
    current_user.favourites << @snop

    # Recalculate the snop popularity
    recalc_popularity(@snop, 1)
  	
    respond_to do |format|
      format.js
    end
  end

  #POST /fave_snops/unfavourite
  def unfavourite
    # Find the fave snop
    @snop = Snop.find(params[:snop])

    # Is the snop the current users snop?
    @current_users_snop = current_user.snops.exists?(@snop)
    @current_users_page = URI(request.referrer).path == user_path(current_user)

    # Finally... delete the entry
    current_user.favourites.destroy(@snop)
  	
    # Recalculate the snop popularity
    # In this case, we'll just decay it. This means that favouriting something 
    # isn't exactly a reversible process, because once you unfavourite it, it 
    # decays instead of "removing" the popularity you just added
    recalc_popularity(@snop, 0)
    
  	respond_to do |format|
      format.js
    end
  end
end
