class ResourceTable
  include Rails.application.routes.url_helpers

  delegate :params, :time_ago_in_words, :link_to, to: :@view

  def initialize(view, all_snops, domain_id, resource_id)
    @view = view
    @all_snops = all_snops
    @domain_id = domain_id
    @resource_id = resource_id
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
      title_link = link_to snop.title, resource_path(domain_id: @domain_id, resource_id: @resource_id, snop: snop, browse_view: true, iSortCol_0: params[:iSortCol_0], sSortDir_0: params[:sSortDir_0], sSearch: params[:sSearch]), remote: true
      [
        user_link,
        title_link,
        domain_link,
        time_ago_in_words(snop.created_at) + " ago",
        ""
      ]
    end
  end
end