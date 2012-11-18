# The table on the User page
class UserTable < BaseTable

  # Initailize our User Table
  def initialize(view, all_snops, pre_filter_count, post_filter_count, user)
    super(view, all_snops, pre_filter_count, post_filter_count)
    @user = user
  end

protected

  # Returns the JSON data for the Users table
  def get_data
    @all_snops.map do |snop|

      # The title will call the same path, but just the JS version, allowing us to
      # switch to the browse view
      title = link_to snop.title, user_path(id: @user.id, snop: snop, browse_view: true, iSortCol_0: params[:iSortCol_0], sSortDir_0: params[:sSortDir_0], sSearch: params[:sSearch]), remote: true
      user = snop.user.username
      domain = snop.domain.uri unless snop.domain.nil?
      created = time_ago_in_words(snop.created_at) + " ago"

      # Lets find the category for this snop and user pair
      category = snop.user_categories.where("user_id = ?", @user.id).first

      # if they're on their own page they can change categories.
      if (@user == current_user)
        selected = category.nil? ? nil : category.id
        # category = collection_select :user_category, :id, current_user.user_categories, :id, :name, { include_blank: true, selected: selected}, { data: { remote: true, method: :post, url: url_for(:controller => "user_categories", action: "set_snop", snop: snop, only_path: true)} }
      end

      category = category.name unless category.nil?

      # Lets give the row an id so that we can find it later (for deletion using JS)
      row_id = snop.id.to_s
      {
        "DT_RowId" => row_id,
        "DT_RowClass" => "rowClass",
        "0" => title,
        "1" => user,
        "2" => domain,
        "3" => created,
        "4" => category
      }
    end
  end
end