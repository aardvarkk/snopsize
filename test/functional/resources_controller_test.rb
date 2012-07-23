require 'test_helper'

class ResourcesControllerTest < ActionController::TestCase
  test "should get show" do
    get :show
    assert_response :success
  end

end
