class UserCategoriesController < ApplicationController
  before_filter :authenticate_user!

  def index
  end

  # GET /user_categories/new
  # GET /user_categories/new.json
  def new
    @user_category = UserCategory.new

    respond_to do |format|
      format.html # new.html.erb
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
    @user_category.user_id = current_user.id;

    respond_to do |format|
      if @user_category.save
        format.html { redirect_to user_categories_path, notice: 'User category was successfully created.' }
        format.js
      else
        format.html { render action: "new" }
        format.js
      end
    end
  end

  # PUT /user_categories/1
  # PUT /user_categories/1.json
  def update
    @user_category = UserCategory.find(params[:id])

    respond_to do |format|
      if @user_category.update_attributes(params[:user_category])
        format.html { redirect_to user_categories_path, notice: 'User category was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /user_categories/1
  # DELETE /user_categories/1.json
  def destroy
    @user_category = UserCategory.find(params[:id])
    @user_category.destroy

    respond_to do |format|
      format.html { redirect_to user_categories_path }
    end
  end
  
  # POST /user_categories/set_snop
  def set_snop
  	snop = Snop.find(params[:snop])

  	# First we have to check if the snop we selected already
    # has a category for the current user
    old_category = snop.user_categories.where('user_id = ?', current_user.id).first

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
