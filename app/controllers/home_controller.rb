class HomeController < ApplicationController
  def index
    # Get a list of the "trending" snops to show (for now just the last 5)
    @snops = Snop.where(deleted: false).order("created_at DESC").limit(5)
    @snops = @snops.to_a

    # Check if a direction is passed in (For JS animation)
    @direction = params[:direction].to_s if params.has_key?(:direction)

    # Check if a snop has been passed in
    @snop = Snop.find(params[:snop]) if (params.has_key?(:snop))
    
    # Respond with the appropriate data
    respond_to do |format|
      format.html #index.html.erb
      format.js   #index.js.erb
    end
  end
end
