class ResourcesController < ApplicationController
  include DatatableHelpers

  # GET /domains/:domain_id/resources/:resource_id
  def show
    # Get the resrouce and all the snops for it
    @resource = Resource.find(params[:resource_id])
    @snops = @resource.snops.where(deleted: false)
    @url = @resource.domain.uri + @resource.uri
    
    # Lets see if they passed in an ordering
    if params.has_key?(:iSortCol_0) && params.has_key?(:sSortDir_0)
      # Sort by domains
      if (sort_column == "domain")
        @snops = @snops.joins(:domain).order("domain_id IS NULL, domains.uri #{sort_direction}")
      # order by username
      elsif (sort_column == "user")
        @snops = @snops.joins(:user).order("users.username #{sort_direction}")
      # order by title or date, this is straight forward
      else 
        @snops = @snops.order("#{sort_column} #{sort_direction}") 
      end
    end

    # Handle pagination next
    @snops = @snops.page(page).per_page(per_page) if params.has_key?(:iDisplayStart) && params.has_key?(:iDisplayLength)

    # Check if a direction is passed in (For JS animation)
    @direction = params[:direction].to_s if params.has_key?(:direction)
    # Check if we are in browse view
    @browse_view = params[:browse_view] == "true" if params.has_key?(:browse_view)
    # Check if a single snop has been passed in to display in browse view
    @snop = Snop.find(params[:snop]) if (params.has_key?(:snop)) && @browse_view

    # Convert snops to an array
    @snops = @snops.to_a

    respond_to do |format|
      format.html
      format.json { render json: ResourceTable.new(view_context, @snops, params[:domain_id], params[:resource_id]) }
      format.js 
    end
  end
end
