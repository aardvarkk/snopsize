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
      title = link_to(snop.title, root_path(snop: snop), remote: true)
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