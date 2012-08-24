class SnopsController < ApplicationController
  include ApplicationHelper
  include UserHelper

  before_filter :authenticate_auth!, :except => [:show]
  before_filter :verify_snop_owner, :only => [:destroy]

  def verify_snop_owner
    redirect_to current_auth if Snop.find(params[:id]).user != current_auth
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
end
