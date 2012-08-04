require 'test_helper'

class DomainsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  
  setup do
    @domain = domains(:one)
  end

  test "should get show" do
    get :show, id: @domain
    assert_response :success
  end

end
