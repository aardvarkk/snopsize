class HomeController < ApplicationController
  def index

    # Provide some default values
    params[:browse_view] ||= false
    params[:snop] ||= nil

    # Set variables
    @snops = Snop.where(deleted: false, is_ad: false).order("popularity DESC").limit(5).to_a
    @snop = Snop.find(params[:snop]) if params[:snop]

    respond_to do |format|
      format.html
      format.json { render json: HomeTable.new(view_context, @snops) }
      format.js 
    end

  end
end
