class SearchTable
  include Rails.application.routes.url_helpers

  delegate :params, :link_to, to: :@view

  def initialize(view, all_snops)
    @view = view
    @all_snops = all_snops
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: @all_snops.length,
      iTotalDisplayRecords: @all_snops.length,
      aaData: data
    }
  end

private

  def data
    @all_snops.map do |snop|
      user_link = link_to snop.user.username, snop.user
      domain_link = link_to snop.domain.uri, snop.domain unless snop.domain.nil?
      # The title will call the same path, but just the JS version, allowing us to
      # switch to the browse view
      title_link = link_to snop.title, search_path(q: params[:q], type: params[:type], snop: snop, browse_view: true, iSortCol_0: params[:iSortCol_0], sSortDir_0: params[:sSortDir_0]), remote: true
      [
        user_link,
        title_link,
        domain_link,
        snop.created_at.to_s,
        "",
        ""
      ]
    end
  end
end