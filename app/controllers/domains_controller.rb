class DomainsController < ApplicationController
  def show
  	@domain = Domain.find(params[:id])
  	@resources = @domain.resources.joins(:snops).where("snops.deleted = ?", false)

    case sort_column()
    # Sort by num_snops
    when "num_snops"
      @resources = @resources.joins(:snops).group("resources.id").order("COUNT(resources.id) #{sort_direction}")
    # order by last_snopped_about
    when "last_snopped_about"
      @resources = @resources.joins(:snops).order("snops.created_at #{sort_direction}").uniq
    # order by resource name
    else 
      @resources = @resources.order("#{sort_column()} #{sort_direction()}") 
    end

    # The user typed in a search so we'll try to find "like" resources
    if params[:sSearch].present?
      @resources = @resources.where("uri like :search", search: "%#{params[:sSearch]}%")
    end

    # Handle pagination next
    @resources = @resources.page(page()).per_page(per_page()).to_a

    respond_to do |format|
      format.html
      format.json { render json: DomainTable.new(view_context, @resources) }
      format.js 
    end
  end

  private
    def page
      params[:iDisplayStart].to_i/per_page + 1
    end

    def per_page
      params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
    end

    def sort_column
      columns = %w[uri num_snops last_snopped_about]
      columns[params[:iSortCol_0].to_i]
    end

    def sort_direction
      params[:sSortDir_0] == "desc" ? "desc" : "asc"
    end
end
