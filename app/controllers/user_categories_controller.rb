class UserCategoriesController < ApplicationController
  before_filter :authenticate_auth!

  # GET /user_categories/new
  # GET /user_categories/new.json
  def new
    @user_category = UserCategory.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user_category }
    end
  end

  # GET /user_categories/1/edit
  def edit
    @user_category = UserCategory.find(params[:id])
  end

  # POST /user_categories
  # POST /user_categories.json
  def create
    @user_category = UserCategory.new(params[:user_category])
    @user_category.user_id = current_auth.id;

    respond_to do |format|
      if @user_category.save
        format.html { redirect_to current_auth, notice: 'User category was successfully created.' }
        format.json { render json: @user_category, status: :created, location: @user_category }
      else
        format.html { render action: "new" }
        format.json { render json: @user_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /user_categories/1
  # PUT /user_categories/1.json
  def update
    @user_category = UserCategory.find(params[:id])

    respond_to do |format|
      if @user_category.update_attributes(params[:user_category])
        format.html { redirect_to current_auth, notice: 'User category was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_categories/1
  # DELETE /user_categories/1.json
  def destroy
    @user_category = UserCategory.find(params[:id])
    @user_category.destroy

    respond_to do |format|
      format.html { redirect_to current_auth }
      format.json { head :no_content }
    end
  end
  
  # POST /user_categories/set_snop
  def set_snop
  	snop = Snop.find(params[:snop])

  	# First we have to check if the snop we selected already
    # has a category for the current user
    old_category = snop.user_categories.where('user_id = ?', current_auth.id).first

    # if old category exists, remove snop from old category
    old_category.snops.destroy(snop) unless old_category.nil?

    if (UserCategory.exists?(params[:user_category][:id]))
      user_category = UserCategory.find(params[:user_category][:id])
        
  	  # add the snop to the new category
  	  user_category.snops << snop
    end

    # nothing to render
    render nothing: true
  end
end
