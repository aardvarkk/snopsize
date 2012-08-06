require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  # Should be able to retrieve a user page
  test "should get user page" do
    # HTTP GET on users#show
    get :show, id: users(:one)

    # Successful result
    assert_response :success

    # @user should be set
    assert_not_nil assigns(:user)

    # @user should be users(:one)
    assert_equal users(:one).username, assigns(:user).username
  end

end
