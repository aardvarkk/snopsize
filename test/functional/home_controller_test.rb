require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  
  test "should get index" do
    # Try to get the home page
    get :index

    # Should be able to get it
    assert_response :success

    # Load some snops that we want to show
    assert_not_nil assigns(:snops)
  end

end
