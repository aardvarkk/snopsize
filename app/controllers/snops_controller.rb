class SnopsController < ApplicationController
  include ApplicationHelper
  include UserHelper

  before_filter :authenticate_auth!, :except => [:show]
  before_filter :verify_snop_owner, :only => [:destroy]

  def verify_snop_owner
    redirect_to current_auth if Snop.find(params[:id]).user != current_auth
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
        format.html { redirect_to @snop.user, notice: 'Snop was successfully created.' }
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
    # Get the snop we want to delete
    @snop = Snop.find(params[:id])

    # Don't actually destroy it, just mark it as deleted!
    @snop.update_attribute(:deleted, true)

    respond_to do |format|
      format.html { redirect_to @snop.user }
      format.json { head :no_content }
      format.js
    end

  end
end
