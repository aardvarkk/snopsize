class UserTable
  include Rails.application.routes.url_helpers

  delegate :params, :link_to, :button_to, :current_auth, :auth_signed_in?, to: :@view

  def initialize(view, all_snops, user)
    @view = view
    @all_snops = all_snops
    @user = user
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
      title_link = link_to snop.title, user_path(id: @user.id, snop: snop, browse_view: true, iSortCol_0: params[:iSortCol_0], sSortDir_0: params[:sSortDir_0]), remote: true

      # Now lets create the delete button if the user is on their own page
      if (auth_signed_in? && current_auth.snops.exists?(snop) && @user == current_auth)
        delete_btn = button_to 'Delete', snop, :data => { :confirm => 'Are you sure?' }, remote: true, method: :delete
      end

      # Lets give the row an id so that we can find it later (for JS in this instance)
      row_id = "row_" + snop.id.to_s

      {
        "DT_RowId" => row_id,
        "DT_RowClass" => "rowClass",
        "0" => user_link,
        "1" => title_link,
        "2" => domain_link,
        "3" => snop.created_at.to_s,
        "4" => "",
        "5" => delete_btn
      }
    end
  end
end