require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  # Should be able to retrieve a user page
  test "should get user page" do
    # HTTP GET on users#show
    get :show, id: users(:one)

    # Successful result
    assert_response :success

    # @user should be set
    assert_not_nil assigns(:user)

    # @user should be users(:one)
    assert_equal users(:one).username, assigns(:user).username
  end

  test "shouldn't show deleted snops on own user page" do

    # HTTP GET on users#show
    get :show, id: users(:two)

    # Iterate through each of the all_snops and make sure none of them is deleted
    assigns(:uncategorized_snops).each do |snop|
      assert_equal false, snop.deleted
    end

  end

  test "shouldn't show the same snop twice" do

    get :show, id: users(:two)

    # Make sure there are no duplicates in the snops
    assert_equal assigns(:all_snops).length, assigns(:all_snops).uniq.length

  end

end
