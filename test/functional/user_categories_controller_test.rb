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

    assert_redirected_to @user
  end

  test "should get edit" do
    get :edit, id: @user_category
    assert_response :success
  end

  test "should update user_category" do
    put :update, id: @user_category, user_category: { name: @user_category.name, parent_id: @user_category.parent_id, user_id: @user_category.user_id }
    assert_redirected_to @user
  end

  test "should destroy user_category" do
    assert_difference('UserCategory.count', -1) do
      delete :destroy, id: @user_category
    end

    assert_redirected_to @user
  end

  test "should add snop user_category" do
  end

  test "should set snop user_category" do
  end
end
