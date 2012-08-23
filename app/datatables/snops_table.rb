class SnopsTable
  include Rails.application.routes.url_helpers

  delegate :params, :link_to, to: :@view

  def initialize(view, all_snops, filtered_snops, show_category)
    @view = view
    @all_snops = all_snops
    @filtered_snops = filtered_snops
    @show_category = show_category
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
    @filtered_snops.map do |snop|
      domain_link = link_to snop.domain.uri, snop.domain unless snop.domain.nil?
      title_link = link_to snop.title, get_snops_path(snop: snop, snops: @all_snops, snop_view: true, show_category: @show_category), remote: true
      if (@show_category)
        [
          title_link,
          domain_link,
          snop.created_at.to_s,
          "Some Category"
        ]
      else
        [
          title_link,
          domain_link,
          snop.created_at.to_s
        ]
      end
    end
  end
end