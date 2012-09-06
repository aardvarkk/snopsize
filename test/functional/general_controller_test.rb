require 'test_helper'

class GeneralControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "should get about" do
    get :about
    assert_response :success
  end

  test "should get help" do
    get :help
    assert_response :success
  end

end
