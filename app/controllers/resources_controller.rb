class ResourcesController < ApplicationController
  include DatatableHelpers

  # GET /domains/:domain_id/resources/:resource_id
  def show

    # Default values
    params[:browse_view] ||= false
    params[:snop] ||= nil

    # Get the resrouce and all the snops for it
    @resource = Resource.find(params[:resource_id])
    @snops = @resource.snops.where(deleted: false)
    @url = @resource.domain.uri + @resource.uri
    
    # Sort by domains
    case sort_column()
    when "domain"
      @snops = @snops.includes(:domain).order("domains.uri #{sort_direction()}")
    # order by username
    when "user"
      @snops = @snops.joins(:user).order("users.username #{sort_direction}")
    # order by title or date, this is straight forward
    else 
      @snops = @snops.order("#{sort_column()} #{sort_direction()}") 
    end

    # The user typed in a search so we'll try to find "like" snops
    if params[:sSearch].present?
      @snops = @snops.includes(:user, :domain).where("users.username like :search or snops.title like :search or domains.uri like :search", search: "%#{params[:sSearch]}%")
    end

    # Handle pagination next
    @snops = @snops.page(page()).per_page(per_page()).to_a

    # Check if a single snop has been passed in to display in browse view
    @snop = Snop.find(params[:snop]) if params[:snop]

    respond_to do |format|
      format.html
      format.json { render json: ResourceTable.new(view_context, @snops, params[:domain_id], params[:resource_id]) }
      format.js 
    end
  end
end
