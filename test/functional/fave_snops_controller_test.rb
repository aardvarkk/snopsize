require 'test_helper'

class FaveSnopsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  
  test "should get favourite" do
    get :favourite
    assert_response :success
  end

  test "should get unfavourite" do
    get :unfavourite
    assert_response :success
  end

end
