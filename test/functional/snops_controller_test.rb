require 'test_helper'

class SnopsControllerTest < ActionController::TestCase
  setup do
    @snop = snops(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:snops)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create snop" do
    assert_difference('Snop.count') do
      post :create, snop: { point1: @snop.point1, point2: @snop.point2, point3: @snop.point3, source: @snop.source, summary: @snop.summary, title: @snop.title, user_id: @snop.user_id }
    end

    assert_redirected_to snop_path(assigns(:snop))
  end

  test "should show snop" do
    get :show, id: @snop
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @snop
    assert_response :success
  end

  test "should update snop" do
    put :update, id: @snop, snop: { point1: @snop.point1, point2: @snop.point2, point3: @snop.point3, source: @snop.source, summary: @snop.summary, title: @snop.title, user_id: @snop.user_id }
    assert_redirected_to snop_path(assigns(:snop))
  end

  test "should destroy snop" do
    assert_difference('Snop.count', -1) do
      delete :destroy, id: @snop
    end

    assert_redirected_to snops_path
  end
end
