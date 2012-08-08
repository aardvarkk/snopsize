require 'test_helper'

# Tests User Stories for snopsize.com user management
class UserAdministrationStoriesTest < ActionDispatch::IntegrationTest
  # Story: A user comes to snopsize.com and decides they want
  # to create a snopsize account
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

  # Story: A user has forgotten their password when trying to login
  # and wants to retrieve it.
  test "request password retrieval" do
  end

  # Story: A user wants to log into the site and change their password
  # because they think they current password needs to be stronger.
  test "change password" do
  end
end
