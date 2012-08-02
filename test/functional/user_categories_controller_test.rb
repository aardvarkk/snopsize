require 'test_helper'

class UserCategoriesControllerTest < ActionController::TestCase
  setup do
    @user_category = user_categories(:one)
  end

  test "should create user_category" do
    assert_difference('UserCategory.count') do
      post :create, user_category: { name: @user_category.name, parent_id: @user_category.parent_id, user_id: @user_category.user_id }
    end

    assert_redirected_to user_category_path(assigns(:user_category))
  end

  test "should show user_category" do
    get :show, id: @user_category
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user_category
    assert_response :success
  end

  test "should update user_category" do
    put :update, id: @user_category, user_category: { name: @user_category.name, parent_id: @user_category.parent_id, user_id: @user_category.user_id }
    assert_redirected_to user_category_path(assigns(:user_category))
  end

  test "should destroy user_category" do
    assert_difference('UserCategory.count', -1) do
      delete :destroy, id: @user_category
    end

    assert_redirected_to user_show_page
  end
end
