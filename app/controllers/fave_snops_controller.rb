class FaveSnopsController < ApplicationController
  include ApplicationHelper
  include FaveSnopsHelper
  include UserHelper

  before_filter :authenticate_auth!
	
  #POST /fave_snops/favourite
  def favourite
  	
    # Add a new fave snop entry
  	@snop = Snop.find(params[:snop])
    current_auth.favourites << @snop

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

    # Let's try to move to the next snop since we've unfaved this one,
    # in case we want to display it.
    all_snops = get_all_snops_for_user(current_auth)
    if (snop_has_next_in_list?(@snop, all_snops))
      @snop_to_show = snop_get_next_in_list(@snop, all_snops)
    elsif (snop_has_prev_in_list?(@snop, all_snops))
      @snop_to_show = snop_get_prev_in_list(@snop, all_snops)
    end

    # In the case of the user unfavouriting one of his own
    # created snops, we just leave it because it'll be displayed
    # anyway since he created it!
    if current_auth.snops.exists?(@snop)
      @snop_to_show = @snop
    end

    # Set the showing snop in the session, or delete it if we
    # just unfaved the last snop.
    if (@snop_to_show)
      session[:showing_snop_id] = @snop_to_show.id
    else
      session.delete :showing_snop_id
    end

    # Finally... delete the entry
    current_auth.favourites.destroy(@snop)
  	
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
