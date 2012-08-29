class UsersController < ApplicationController
  include UserHelper
  include DatatableHelpers

  # Need to authenticate if we want to change the settings
  before_filter :authenticate_user!, only: :settings

  # GET /users/:id/settings
  def settings
  end

  # GET /users/:id
  def show

    # Default values
    params[:browse_view] ||= false

    # Get the user specified
    @user = User.find(params[:id])

    # Get all the snops for our user
    @snops = get_all_snops_for_user(@user)
    # Get the relation 
    @snops = Snop.where("snops.id IN (?)", @snops)

    # Sort by domains
    case sort_column()
    when "domain"
      @snops = @snops.includes(:domain).order("domains.uri #{sort_direction()}")
    # order by username
    when "user"
      @snops = @snops.joins(:user).order("users.username #{sort_direction()}")
    # order by category
    when "category"
      @snops = @snops.includes(:user_categories).order("user_categories.name #{sort_direction}")
    # order by title or date, this is straight forward
    else 
      @snops = @snops.order("#{sort_column()} #{sort_direction()}") 
    end

    # The user typed in a search so we'll try to find "like" snops
    if params[:sSearch].present?
      @snops = @snops.includes(:user, :domain, :user_categories).where("users.username like :search or snops.title like :search or domains.uri like :search or user_categories.name like :search", search: "%#{params[:sSearch]}%")
    end

    # Handle pagination next
    @snops = @snops.page(page()).per_page(per_page()).to_a

    # Check if a single snop has been passed in to display in browse view
    @snop = Snop.find(params[:snop]) if params[:snop]

    respond_to do |format|
      format.html
      format.json { render json: UserTable.new(view_context, @snops, @user) }
      format.js 
    end
  end
end
