require 'test_helper'

class GeneralControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "should get about" do
    get :about
    assert_response :success
  end

  # No more help page...
  # test "should get help" do
  #   get :help
  #   assert_response :success
  # end

end
