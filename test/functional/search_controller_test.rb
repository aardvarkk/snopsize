require 'test_helper'

class SearchControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "should get search" do
    # Try to get the search page
    get :search

    # Should be a successful query
    assert_response :success

    # Make sure the results are set
    assert_nil assigns(:results)
  end

  test "should get search with results" do
    # Try to get the search page
    get :search, q: "test"

    # Should be a successful query
    assert_response :success

    # Make sure the results are set
    assert_not_nil assigns(:results)
  end

end
