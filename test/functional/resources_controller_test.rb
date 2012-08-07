require 'test_helper'

class ResourcesControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  
  setup do
    @resource = resources(:one)
  end

  test "should get show" do
    # Try to show the resource and all of it's snops
    get :show, domain_id: @resource.domain.id, resource_id: @resource.id

    # Should get a success back.
    assert_response :success

    # Make sure that we assign @snops
    assert_not_nil assigns(:snops)
  end

end
