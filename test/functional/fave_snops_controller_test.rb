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
    # Try to fave a snop
    assert_difference('FaveSnop.count') do
      xhr :post, :favourite, snop: @snop
    end

    # Should be a good response
    assert_response :success

    # Make sure @snop is created
    assert_not_nil assigns(:snop)

    # Test that the jquery was executed and that the button
    # says "Unfavourite" now
    assert_select_jquery :html, '#fave' do
      assert_select "input", value: "Unfavourite"
    end
  end

  test "should get unfavourite" do
    # Need to fave before we can unfave
    assert_difference('FaveSnop.count') do
      xhr :post, :favourite, snop: @snop
    end

    # Should be a good response
    assert_response :success

    # Now we unfave
    assert_difference('FaveSnop.count', -1) do
      xhr :post, :unfavourite, snop: @snop
    end

    # Should be a good response
    assert_response :success

    # Make sure @snop is created
    assert_not_nil assigns(:snop)

    # Test that the jquery was executed and that the button
    # says "favourite" now
    assert_select_jquery :html, '#fave' do
      assert_select "input", value: "Favourite"
    end
  end

end
