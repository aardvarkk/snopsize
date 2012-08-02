class ResourcesController < ApplicationController
  def show
  	@snops = Resource.find(params[:id]).snops
  end
end
