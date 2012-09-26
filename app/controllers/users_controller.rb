class UsersController < ApplicationController
  include DatatableHelpers

  # Need to authenticate if we want to change the settings
  before_filter :authenticate_user!, except: :show

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
    @snops = @user.snops.where(deleted: false)

    # Get the relation 
    # Do a default sort by created by date
    @snops = Snop.where("snops.id IN (?)", @snops)

    # Sort by domains
    case sort_column()
    # order by username
    when "user"
      @snops = @snops.joins(:user).order("users.username #{sort_direction()}")
    when "domain"
      @snops = @snops.includes(:domain).order("domains.uri #{sort_direction()}")
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

  # GET /users/:id/favourites
  def favourites

    # We have authenticated, but we also want to make sure this user is US
    # If we're not checking our favourites, just redirect to ours
    if current_user != User.find(params[:id])
      redirect_to user_favourites_path(current_user)
      return
    end

    # Default values
    params[:browse_view] ||= false

    # Get the user specified
    @user = User.find(params[:id])

    @snops = current_user.favourites

    # Sort by domains
    case sort_column()
    # order by username
    when "user"
      @snops = @snops.joins(:user).order("users.username #{sort_direction()}")
    # order by domain
    when "domain"
      @snops = @snops.includes(:domain).order("domains.uri #{sort_direction()}")
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
      format.json { render json: UserFavouritesTable.new(view_context, @snops, @user) }
      format.js 
    end
    
  end

end
