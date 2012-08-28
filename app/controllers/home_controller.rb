class HomeController < ApplicationController
  def index

    # Provide some default values
    params[:browse_view] ||= false
    params[:snop] ||= nil

    # Set variables
    @snops = Snop.where(deleted: false, is_ad: false).order("popularity DESC").limit(5).to_a
    @snop = Snop.find(params[:snop]) if params[:snop]

    # The list view shouldn't show the ads
    snops_no_ads = @snops.dup;

    # If we're the adviewer, plop some ads into the snops
    # They'll get shown in the browse view
    if auth_signed_in? && current_auth.username == 'adviewer'
      # Get all of the ad snops... limiting to some number
      # This doesn't have to work like this, but it's easy to start with
      @ads = Snop.where(deleted: false, is_ad: true).to_a

      # Insert the ads
      (1..@snops.length).step(5).each { |i| @snops.insert(i, @ads[rand(@ads.length)]) }
    end

    respond_to do |format|
      format.html
      format.json { render json: HomeTable.new(view_context, snops_no_ads) }
      format.js 
    end

  end
end
