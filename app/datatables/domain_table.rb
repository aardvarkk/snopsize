# The table on the Domain page
class DomainTable < BaseTable

  # Initailize our Domain Table
  def initialize(view, all_snops, pre_filter_count, post_filter_count, domain_id)
    super(view, all_snops, pre_filter_count, post_filter_count)
    @domain_id = domain_id
  end

protected

  # Get the JSON for the table on the domain page
  def get_data
    @all_snops.map do |snop|
      title = link_to(snop.title, domain_path(id: @domain_id, snop: snop, browse_view: true, iSortCol_0: params[:iSortCol_0], sSortDir_0: params[:sSortDir_0], sSearch: params[:sSearch]), remote: true)
      user = snop.user.username
      domain = snop.domain.uri unless snop.domain.nil?
      created = time_ago_in_words(snop.created_at) + " ago"
      [
        title,
        user,
        domain,
        created,
        ""
      ]
    end
  end
end