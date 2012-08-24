class HomeController < ApplicationController
  def index
    # Get a list of the "trending" snops to show (for now just the last 5)
    @snops = Snop.where(deleted: false).order("title DESC").limit(5)
    @snops = @snops.to_a

    # Check if a direction is passed in (For JS animation)
    @direction = params[:direction].to_s if params.has_key?(:direction)
    # Check if we are in browse view
    @browse_view = params[:browse_view] == "true" if params.has_key?(:browse_view)
    # Check if a single snop has been passed in to display in browse view
    @snop = Snop.find(params[:snop]) if (params.has_key?(:snop)) && @browse_view

    respond_to do |format|
      format.html
      format.json { render json: HomeTable.new(view_context, @snops) }
      format.js 
    end
  end
end
