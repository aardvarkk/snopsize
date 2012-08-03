require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @user = users(:one)
  end

  test "should get show" do
    get :show, id: @user
    assert_response :success
  end

end
