class DomainTable
  include Rails.application.routes.url_helpers

  delegate :params, :time_ago_in_words, :link_to, to: :@view

  def initialize(view, all_resources)
    @view = view
    @all_resources = all_resources
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: @all_resources.length,
      iTotalDisplayRecords: @all_resources.length,
      aaData: data
    }
  end

private

  def data
    @all_resources.map do |resource|
      resource_link = link_to resource.uri, resource_path(domain_id: resource.domain_id, resource_id: resource.id)
      num_snops = resource.snops.length
      last_snopped_about = resource.snops.order("created_at DESC").first
      last_snopped_about = time_ago_in_words(last_snopped_about.created_at) + " ago"

      [
        resource_link,
        num_snops,
        last_snopped_about
      ]
    end
  end
end