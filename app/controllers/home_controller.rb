class HomeController < ApplicationController
  def index
    # Get a list of the most popular snops
    @snops = Snop.where(deleted: false).order("popularity DESC").limit(5)
    @snops = @snops.to_a

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
