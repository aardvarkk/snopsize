require 'test_helper'

class UserCategoriesControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @user = users(:one)
    sign_in @user
    @user_category = user_categories(:one)
  end

  teardown do
    sign_out @user
  end

  test "should create user_category" do
    assert_difference('UserCategory.count') do
      post :create, user_category: { name: @user_category.name + "A", parent_id: @user_category.parent_id, user_id: @user_category.user_id }
    end

    # Should go back to User page
    assert_redirected_to @user

    # a user category should be assigned
    assert_not_nil assigns(:user_category)

    # Make sure the variables are the same that we requested
    assert_equal @user_category.name + "A", assigns(:user_category).name
    assert_equal @user_category.parent_id, assigns(:user_category).parent_id
    assert_equal @user_category.user_id, assigns(:user_category).user_id
  end

  test "should get edit" do
    # Try to get the user category edit page
    get :edit, id: user_categories(:one)

    # make sure it's gotten
    assert_response :success

    # @user_category should be assigned
    assert_not_nil assigns(:user_category)

    # Make sure the user category is the one we requested
    assert_equal user_categories(:one).name, assigns(:user_category).name
    assert_equal user_categories(:one).parent_id, assigns(:user_category).parent_id
    assert_equal user_categories(:one).user_id, assigns(:user_category).user_id
  end

  test "should update user_category" do
    # Try to update the user_cateogyr
    put :update, id: @user_category, user_category: { name: @user_category.name + "C", parent_id: @user_category.parent_id, user_id: @user_category.user_id }

    # Should go back to user page
    assert_redirected_to @user

    # @user_category should be assigned
    assert_not_nil assigns(:user_category)

    # Make sure the user category is the one we requested
    assert_equal @user_category.name + "C", assigns(:user_category).name
    assert_equal @user_category.parent_id, assigns(:user_category).parent_id
    assert_equal @user_category.user_id, assigns(:user_category).user_id
  end

  test "should destroy user_category" do
    # Try to delete the category
    assert_difference('UserCategory.count', -1) do
      delete :destroy, id: @user_category
    end

    # Make sure we go back to the user page
    assert_redirected_to @user

    # User category will be assigned
    assert_not_nil assigns(:user_category)
  end

  test "should add snop user_category" do
    snop = @user.snops.first

    # Try to get the "add_snop" page
    get :add_snop, snop: snop

    # make sure it's gotten
    assert_response :success

    # @user_category should be assigned
    assert_not_nil assigns(:user_category)
    assert_not_nil assigns(:snop)
    assert_not_nil assigns(:user_categories)

    # Make sure the snop is the one we requested
    assert_equal snop.id, assigns(:snop).id
  end

  test "should set snop user_category" do
    snop = @user.snops.first

    # Make sure that we can fave the snop
    assert_difference ('@user.categorized_snops.count') do
      post :set_snop, {snop: snop, user_category: {id: @user_category.id}}
    end

    # Should go back to User page
    assert_redirected_to @user
  end
end
