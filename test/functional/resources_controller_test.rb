require 'test_helper'

class ResourcesControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  
  setup do
    @resource = resources(:one)
  end

  test "should get show" do
    get :show, domain_id: @resource.domain.id, id: @resource
    assert_response :success
  end

end
