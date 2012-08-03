require 'test_helper'

class SnopsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @snop = snops(:one)
    sign_in @snop.user
  end

  teardown do
    sign_out @snop.user
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create snop" do
    assert_difference('Snop.count') do
      post :create, snop: { point1: @snop.point1, point2: @snop.point2, point3: @snop.point3, domain_id: @snop.domain_id, resource_id: @snop.resource_id, summary: @snop.summary, title: @snop.title, user_id: @snop.user_id }
    end

    assert_redirected_to snop_path(assigns(:snop))
  end

  test "should show snop" do
    get :show, id: @snop
    assert_response :success
  end

  test "should destroy snop" do
    assert_difference('Snop.count', -1) do
      delete :destroy, id: @snop
    end

    assert_redirected_to snops_path
  end
end
