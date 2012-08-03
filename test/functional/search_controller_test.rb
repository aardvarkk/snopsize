require 'test_helper'

class SearchControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "should get search" do
    get :search
    assert_response :success
  end

end
