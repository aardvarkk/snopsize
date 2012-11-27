require 'test_helper'

class SearchControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "should get search with no type" do
    # Try to get the search page with no type passed
    get :search

    # Should be a successful query
    assert_response :success

    # Make sure the results are set to nil
    assert_nil assigns(:results)
  end

  test "should get keyword search" do
    # Try to get the search page with keyword search
    # specified this time
    get :search, type: "keyword"

    # Should be a successful query
    assert_response :success

    # Make sure the results are nil
    assert_nil assigns(:results)

    # Now lets try it with some data
    get :search, type: "keyword", q: "point"

    # Shoud be a successful query
    assert_response :success

    # Make sure results are not nil
    assert_not_nil assigns(:results)
  end

  test "should get url search" do
    # Try to get the search page
    get :search, type: "url"

    # Should be a successful query
    assert_response :success

    # Make sure the results are set
    assert_nil assigns(:results)

    # Now lets try with some data
    get :search, type: "url", q: domains(:one).uri

    # We should be redirected to the domain page for this domain
    assert_redirected_to domain_path(domains(:one))

    # Now lets try with an invalid uri
    get :search, type: "url", q: "somegibberish"

    # Should be a successful query
    assert_response :success

    # Make sure the results are set
    assert_nil assigns(:results)
  end

  test "should get user search" do
    # Try to get the search page
    get :search, type: "user"

    # Should be a successful query
    assert_response :success

    # Make sure the results are set
    assert_nil assigns(:results)

    # Now lets try with some data
    get :search, type: "user", q: "auser"

    # Should be a successful query
    assert_response :success

    # Make sure the results are set
    assert_not_nil assigns(:results)
  end

end
