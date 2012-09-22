class DomainsController < ApplicationController
  include DatatableHelpers

  # GET /domains/:id
  def show
    # Default values
    params[:browse_view] ||= false
    params[:snop] ||= nil

    # Get the domain and all the snops for it
    @domain = Domain.find(params[:id])
    @snops = Snop.where("resource_id IN (?)", @domain.resources)
    
    # Sort by domains
    case sort_column()
    when "domain"
      @snops = @snops.includes(:resource).order("resources.uri #{sort_direction()}")
    # order by username
    when "user"
      @snops = @snops.joins(:user).order("users.username #{sort_direction}")
    # order by title or date, this is straight forward
    else 
      @snops = @snops.order("#{sort_column()} #{sort_direction()}") 
    end

    # The user typed in a search so we'll try to find "like" snops
    if params[:sSearch].present?
      @snops = @snops.includes(:user, :resource).where("users.username like :search or snops.title like :search or resources.uri like :search", search: "%#{params[:sSearch]}%")
    end

    # Handle pagination next
    @snops = @snops.page(page()).per_page(per_page()).to_a

    # Check if a single snop has been passed in to display in browse view
    @snop = Snop.find(params[:snop]) if params[:snop]

    respond_to do |format|
      format.html
      format.json { render json: DomainTable.new(view_context, @snops, params[:id]) }
      format.js 
    end
  end
end
