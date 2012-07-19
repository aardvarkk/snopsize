class SnopsController < ApplicationController
  before_filter :authenticate_user!, :except => [:show, :index]	
	
  # GET /snops
  # GET /snops.json
  def index
    @snops = Snop.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @snops }
    end
  end

  # GET /snops/1
  # GET /snops/1.json
  def show
    @snop = Snop.find(params[:id])
    @user = User.find(@snop.user_id)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @snop }
    end
  end

  # GET /snops/new
  # GET /snops/new.json
  def new
    @snop = Snop.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @snop }
    end
  end

  # GET /snops/1/edit
  def edit
    @snop = Snop.find(params[:id])
  end

  # POST /snops
  # POST /snops.json
  def create
    @snop = Snop.new(params[:snop])
            
    # Set the user_id to the logged in user, since
    # only logged in users can create snops
    @user = current_user
    @snop.user_id = current_user.id 

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

  # PUT /snops/1
  # PUT /snops/1.json
  def update
    @snop = Snop.find(params[:id])

    respond_to do |format|
      if @snop.update_attributes(params[:snop])
        format.html { redirect_to @snop, notice: 'Snop was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @snop.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /snops/1
  # DELETE /snops/1.json
  def destroy
    @snop = Snop.find(params[:id])
    @snop.destroy

    respond_to do |format|
      format.html { redirect_to snops_url }
      format.json { head :no_content }
    end
  end
end
