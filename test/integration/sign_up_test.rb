require 'test_helper'

# Story: A user comes to snopsize.com and decides they want
# to create a snopsize account
class SignUpTest < ActionDispatch::IntegrationTest
  include Devise

  test "create account and go to user page" do
    # Go to home page
    get "/"
    assert_response :success

    # Go to sign-up page
    get "/signup"
    assert_response :success

    # Fill out the registration form and send it
    post_via_redirect "/users", user: {username: "tester", email: "tester@tester.com", password: "tester", password_confirmation: "tester" }

    # Make sure that our redirect takes us back to the home page
    assert_equal "/", path 
  end
end
