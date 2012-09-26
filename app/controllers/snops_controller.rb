class SnopsController < ApplicationController
  include ApplicationHelper

  before_filter :authenticate_user!, :except => [:show, :like]
  before_filter :verify_snop_owner, :only => [:destroy]

  def verify_snop_owner
    render status: 403 if Snop.find(params[:id]).user != current_user
  end

  # GET /snops/new
  # GET /snops/new.json
  def new
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

    respond_to do |format|
      if @snop.save
        # Only set the category if the snop validates correctly
        # Check if a valid category has been specified and add the snop to
        # that category
        if (params.has_key?(:user_category) && UserCategory.exists?(params[:user_category][:id]))
          UserCategory.find(params[:user_category][:id]).snops << @snop
        end

        format.html { redirect_to user_path(current_user), notice: 'Snop was successfully created.' }
      else

        # Need to set this default_uri, because the form can be pre-filled if you're snopping about a particular URI
        # As a result, if we don't set this value and there are validation errors, the URI box will be emptied out. This way, we're able to keep the textbox filled with whatever was there previously
        @default_uri = params[:snop][:uri]

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

  def show
    @snop = Snop.find(params[:id])
  end

  def like

    # Need the snop to generate metadata
    @snop = Snop.find(params[:id])

    # We don't want all the application layout stuff
    render :layout => false
    
  end

end
