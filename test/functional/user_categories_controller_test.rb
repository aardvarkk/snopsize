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
      post :create, user_category: { name: @user_category.name + "A", user_id: @user_category.user_id }
    end

    # Should go back to the user categories
    assert_redirected_to user_categories_path

    # a user category should be assigned
    assert_not_nil assigns(:user_category)

    # Make sure the variables are the same that we requested
    assert_equal @user_category.name + "A", assigns(:user_category).name
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
    assert_equal user_categories(:one).user_id, assigns(:user_category).user_id
  end

  test "should update user_category" do
    # Try to update the user_cateogyr
    put :update, id: @user_category, user_category: { name: @user_category.name + "C", user_id: @user_category.user_id }

    # Should go back to user categories page
    assert_redirected_to user_categories_path

    # @user_category should be assigned
    assert_not_nil assigns(:user_category)

    # Make sure the user category is the one we requested
    assert_equal @user_category.name + "C", assigns(:user_category).name
    assert_equal @user_category.user_id, assigns(:user_category).user_id
  end

  test "should destroy user_category" do
    # Try to delete the category
    assert_difference('UserCategory.count', -1) do
      delete :destroy, id: @user_category
    end

    # Make sure we go back to the user categories
    assert_redirected_to user_categories_path

    # User category will be assigned
    assert_not_nil assigns(:user_category)
  end

  test "should set snop user_category" do
    snop = @user.snops.first

    # Make sure that we can fave the snop
    assert_difference ('@user.categorized_snops.count') do
      post :set_snop, {snop: snop, user_category: {id: @user_category.id}}
    end

    # Should return OK and keep us on same page
    assert :success
  end
end
