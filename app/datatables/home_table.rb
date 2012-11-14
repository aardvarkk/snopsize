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
      
      # The title will call the same path, but just the JS version, allowing us to
      # switch to the browse view
      title_link = '<div class="snop_title">' + link_to(snop.title, root_path(snop: snop, browse_view: true), remote: true) + '</div>'
      user = snop.user.username
      domain = snop.domain.uri unless snop.domain.nil?      

      [
        title_link,
        user,
        domain,
        time_ago_in_words(snop.created_at) + " ago",
        ""
      ]

    end
  end
end