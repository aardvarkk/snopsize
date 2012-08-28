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
    # HTTP GET /snop/new
    get :new

    # Make sure we can successfully get the new snop page
    assert_response :success

    # Make sure @snop is assigned
    assert_not_nil assigns(:snop)
  end

  test "should create snop" do
    snop = snops(:one)

    # Need to set a referrer or else this wont work!
    session[:new_snop_referrer] = user_path(snop.user)

    # Try to create a new snop
    assert_difference('Snop.count') do
      post :create, snop: { point1: snop.point1, point2: snop.point2, point3: snop.point3, domain_id: snop.domain_id, resource_id: snop.resource_id, summary: snop.summary, title: snop.title, user_id: snop.user_id }
    end

    # Make sure we are redirected properly
    assert_redirected_to user_path(snop.user)

    # Make sure snop is assigned properly
    assert_not_nil assigns(:snop)

    # Make sure we saved the snop properly
    assert_equal snop.title, assigns(:snop).title
    assert_equal snop.point1, assigns(:snop).point1
    assert_equal snop.point2, assigns(:snop).point2
    assert_equal snop.point3, assigns(:snop).point3
    assert_equal snop.summary, assigns(:snop).summary
    assert_equal snop.domain_id, assigns(:snop).domain_id
    assert_equal snop.resource_id, assigns(:snop).resource_id
    assert_equal snop.user_id, assigns(:snop).user_id
  end

  # Should we test that you actually CAN'T show a snop anymore?
  # test "should show snop" do
  #   # HTTP GET /snop/:id
  #   get :show, id: @snop

  #   # Make sure the page is proper
  #   assert_response :success

  #   # make sure that it assigned @snop, and @fave_snop
  #   assert_not_nil assigns(:snop)
  #   assert_nil assigns(:fave_snop)
  # end

  test "should destroy snop" do
    
    # Delete the snop
    delete :destroy, id: @snop

    # Check that it's marked as deleted
    assert_equal true, assigns(:snop).deleted?

    # make sure we are redirected properly to the
    # user page.
    assert_redirected_to assigns(:snop).user

    # Snop will be assigned
    assert_not_nil assigns(:snop)
  end

  test "can't destroy somebody else's snop" do

    # Try to delete it
    delete :destroy, id: snops(:two)

    # Make sure it's not deleted
    assert_equal false, snops(:two).deleted?

    # Make sure we get redirected to our user page
    assert_redirected_to @snop.user

  end

  test "can destroy own snop" do

    # Try to delete it
    delete :destroy, id: snops(:one)

    # Make sure it's deleted
    assert_equal true, assigns(:snop).deleted?

    # Make sure we get redirected to our user page
    assert_redirected_to assigns(:snop).user

  end

end
