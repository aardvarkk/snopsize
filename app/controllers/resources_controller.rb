class ResourcesController < ApplicationController
  def show
    @resource = Resource.find(params[:resource_id])
    @snops = @resource.snops
    @url = @resource.domain.uri + @resource.uri
  end
end
