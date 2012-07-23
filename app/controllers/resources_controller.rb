class ResourcesController < ApplicationController
  def show
  	@snops = Resource.find(params[:resource_id]).snops
  end
end
