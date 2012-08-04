require 'test_helper'

class FaveSnopsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  
  setup do
    @snop = snops(:one)
    sign_in @snop.user
  end

  teardown do
    sign_out @snop.user
  end

  test "should get favourite" do
    assert_difference('FaveSnop.count') do
      xhr :post, :favourite, snop: @snop
    end

    assert_response :success
    # TODO: Test that it was actually updated
  end

  test "should get unfavourite" do
    # Need to fave before we can unfave
    assert_difference('FaveSnop.count') do
      xhr :post, :favourite, snop: @snop
    end

    # Now we unfave
    assert_difference('FaveSnop.count', -1) do
      xhr :post, :unfavourite, snop: @snop
    end

    assert_response :success
    # TODO: Test that it was actually updated
  end

end
