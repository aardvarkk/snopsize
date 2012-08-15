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

  test "should get snop show" do
    # Do an AJAX post
    xhr :post, :show_snop, domain_id: @resource.domain.id, resource_id: @resource.id, snop: @resource.snops.first, direction: "next"

    # Should get a success back.
    assert_response :success

    # make sure that @snop is created
    assert_not_nil assigns(:snop)
  end

  test "shouldn't get snop show" do
    # They requested a snop that's no part of the resource... shouldn't work!
    xhr :post, :show_snop, domain_id: @resource.domain.id, resource_id: @resource.id, snop: snops(:two), direction: "next"

    # Should be redirected to resource page
    assert_redirected_to resource_path(domain_id: @resource.domain.id, resource_id: @resource.id)
  end

end
