class FaveSnopsController < ApplicationController
  include ApplicationHelper
  include UserHelper

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
    # Find the fave snop
    @snop = Snop.find(params[:snop])

    # Let's try to move to the next snop since we've unfaved this one,
    # in case we want to display it.
    all_snops = get_all_snops_for_user(current_user)
    logger.debug all_snops
    if (snop_has_next_in_list?(@snop, all_snops))
      @snop_to_show = snop_get_next_in_list(@snop, all_snops)
    logger.debug "Next Snop: " + @snop_to_show.to_s
    elsif (snop_has_prev_in_list?(@snop, all_snops))
      @snop_to_show = snop_get_prev_in_list(@snop, all_snops)
    logger.debug "Prev Snop: " + @snop_to_show.to_s
    end

    # In the case of the user unfavouriting one of his own
    # created snops, we just leave it because it'll be displayed
    # anyway since he created it!
    if current_user.snops.exists?(@snop)
      @snop_to_show = @snop
      logger.debug "Current SNop:" + @snop_to_show.to_s
    end

    # Finally... delete the entry
    current_user.favourites.destroy(@snop)
  	
  	respond_to do |format|
      format.js
    end
  end
end
