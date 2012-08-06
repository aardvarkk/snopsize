require 'test_helper'

class DomainsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  
  setup do
    @domain = domains(:one)
  end

  test "should get show" do
    # Try to show the domain page
    get :show, id: @domain

    # Should be able to get it ok
    assert_response :success

    # Make sure the domain and resources instances are set
    assert_not_nil assigns(:domain)
    assert_not_nil assigns(:resources)
  end

end
