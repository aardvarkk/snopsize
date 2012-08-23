class SnopsController < ApplicationController
  include ApplicationHelper
  include UserHelper

  before_filter :authenticate_auth!, :except => [:show, :get_snops]
  before_filter :verify_snop_owner, :only => [:destroy]

  def verify_snop_owner
    redirect_to current_auth if Snop.find(params[:id]).user != current_auth
  end

  # GET /get_snops
  def get_snops
    # unless they've provided a list of snops that they want to use
    if params.has_key?(:snops)
      @snops = Snop.where("snops.id IN (?)", params[:snops]) 
    else
      @snops = Snop.all
    end

    # Lets see if they passed in an ordering
    if params.has_key?(:iSortCol_0) && params.has_key?(:sSortDir_0)
      # Sort by domains
      if (sort_column == "domain")
        @snops = @snops.joins(:domain).order("domain_id IS NULL, domains.uri #{sort_direction}")
      # Sory by category
      elsif (sort_column == "category")
        @snops = @snops.joins(:user).order("users.name #{sort_direction}")
      # order by title or date, this is straight forward
      else 
        @snops = @snops.order("#{sort_column} #{sort_direction}") 
      end
    end

    # Handle pagination next
    @snops = @snops.page(page).per_page(per_page) if params.has_key?(:iDisplayStart) && params.has_key?(:iDisplayLength)

    # Check if a direction is passed in (For JS animation)
    @direction = params[:direction].to_s if params.has_key?(:direction)

    # Check if we are using snop_view
    @snop_view = params[:snop_view] == "true" if params.has_key?(:snop_view)

    # Check if the category is showing
    @show_category = params[:show_category] == "true" if params.has_key?(:show_category)

    # Check if a single snop has been passed in to display
    @snop = Snop.find(params[:snop]) if (params.has_key?(:snop))

    # Convert snops to an array (so it can be passed to controllers easier)
    @snops = @snops.to_a

    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { render json: SnopsTable.new(view_context, params[:snops], @snops, @show_category) }
      format.js 
    end
  end

  # GET /snops/1
  # GET /snops/1.json
  def show
    @snop = Snop.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @snop }
    end
  end

  # GET /snops/new
  # GET /snops/new.json
  def new
    @snop = Snop.new

    # Check if we should pre-fill with URI value
    @default_uri = params[:uri] if params.has_key? :uri

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @snop }
    end
  end

  # POST /snops
  # POST /snops.json
  def create
    @snop = Snop.new(params[:snop])

    # Set the user_id to the logged in user, since
    # only logged in users can create snops
    @snop.user = current_auth

    respond_to do |format|
      if @snop.save
        format.html { redirect_to @snop, notice: 'Snop was successfully created.' }
        format.json { render json: @snop, status: :created, location: @snop }
      else
        format.html { render action: "new" }
        format.json { render json: @snop.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /snops/1
  # DELETE /snops/1.json
  def destroy
    # Get the snop that's currently showing
    if (session[:showing_snop_id])
      @showing_snop = Snop.find(session[:showing_snop_id])
    end

    # Get the snop we want to delete
    @snop = Snop.find(params[:id])

    if @showing_snop == @snop
      # Let's try to move to the next snop since we've deleted the showing one,
      # in case we want to display it.
      all_snops = get_all_snops_for_user(current_auth)
      if (snop_has_next_in_list?(@showing_snop, all_snops))
        @snop_to_show = snop_get_next_in_list(@showing_snop, all_snops)
      elsif (snop_has_prev_in_list?(@showing_snop, all_snops))
        @snop_to_show = snop_get_prev_in_list(@showing_snop, all_snops)
      end
    else
      # We're not showing the one they want to delete, so just leave it the same
      @snop_to_show = @showing_snop
    end

    # Set the showing snop in the session, or delete it if we
    # just deleted the last snop for the user
    unless @snop_to_show.nil?
      session[:showing_snop_id] = @snop_to_show.id
    else
      session.delete :showing_snop_id
    end

    # Don't actually destroy it, just mark it as deleted!
    @snop.update_attribute(:deleted, true)

    respond_to do |format|
      format.html { redirect_to @snop.user }
      format.json { head :no_content }
      format.js
    end

  end

  # Helper functions
  private

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[title domain created_at category]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end
