# The table on the Home page
class HomeTable < BaseTable

  # Initailize our Home Table
  def initialize(view, all_snops)
    super(view, all_snops, all_snops.length, all_snops.length)
  end

protected

  # Get the JSON for the table on the home page
  def get_data
    @all_snops.map do |snop|
      user_link = link_to snop.user.username, snop.user
      domain_link = link_to snop.domain.uri, snop.domain unless snop.domain.nil?
      # The title will call the same path, but just the JS version, allowing us to
      # switch to the browse view
      title_link = link_to snop.title, root_path(snop: snop, browse_view: true), remote: true
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