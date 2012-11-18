# The table on the Search results page
class SearchTable < BaseTable

  # Initailize our Search Table
  def initialize(view, all_snops, pre_filter_count, post_filter_count)
    super(view, all_snops, pre_filter_count, post_filter_count)
  end

protected

  # Get the JSON for the table on the search results page
  def get_data
    @all_snops.map do |snop|
      title = link_to snop.title, search_path(q: params[:q], type: params[:type], snop: snop, browse_view: true, iSortCol_0: params[:iSortCol_0], sSortDir_0: params[:sSortDir_0], sSearch: params[:sSearch]), remote: true
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