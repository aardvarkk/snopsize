require 'test_helper'

class ResourcesControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  
  test "should get show" do
    get :show
    assert_response :success
  end

end
