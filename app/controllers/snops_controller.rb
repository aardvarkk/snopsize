class SnopsController < ApplicationController
  include ApplicationHelper
  include UserHelper

  before_filter :authenticate_user!
  before_filter :verify_snop_owner, :only => [:destroy]

  def verify_snop_owner
    redirect_to current_user if Snop.find(params[:id]).user != current_user
  end

  # GET /snops/new
  # GET /snops/new.json
  def new
    # Store where we came from!
    session[:new_snop_referrer] = request.referrer  
    
    # Default parameters
    params[:uri] ||= nil

    # Set variables
    @snop = Snop.new
    @default_uri = params[:uri]

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # POST /snops
  # POST /snops.json
  def create
    @snop = Snop.new(params[:snop])

    # Set the user_id to the logged in user, since
    # only logged in users can create snops
    @snop.user = current_user

    # Get the referrer so we can go back to that page
    referrer = session[:new_snop_referrer]
    session.delete(:referrer)

    respond_to do |format|
      if @snop.save
        format.html { redirect_to referrer, notice: 'Snop was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  # DELETE /snops/1
  # DELETE /snops/1.json
  def destroy
    # Get the snop we want to delete
    @snop = Snop.find(params[:id])

    # Don't actually destroy it, just mark it as deleted!
    @snop.update_attribute(:deleted, true)

    respond_to do |format|
      format.html { redirect_to @snop.user }
      format.js
    end

  end
end
