require 'test_helper'

# Tests User Stories for snopsize.com user management
class UserAdministrationStoriesTest < ActionDispatch::IntegrationTest
  # Story: A user comes to snopsize.com and decides they want
  # to create a snopsize account
  test "create account and go to user page" do
    # Go to home page
    visit('/')
    assert_equal current_path, root_path

    # There should be a link to sign-up
    assert page.has_link? "Sign Up", :href => new_user_registration_path

    # Now lets follow that sign in link
    click_link "Sign Up"

    # Make sure we're on the sign up page
    assert_equal current_path, new_user_registration_path

    # Fill out the sign up form
    fill_in('Username', :with => 'tester')
    fill_in('Email', :with => 'tester@tester.com')
    fill_in('Password', :with => 'tester')
    fill_in('Password confirmation', :with => 'tester')
    click_button "Sign up"

    # We should now be back on the home page and logged in
    assert_equal current_path, root_path

    # Let's make sure that the user can see that they're logged in at the top
    assert page.has_link? 'tester'
  end

  # Story: A user has forgotten their password when trying to login
  # and wants to retrieve it.
  test "request password retrieval" do
#    # Go to home page
#    visit('/')
#    assert_equal current_path, root_path
#
#    # There should be a link to sign-in
#    assert page.has_link? "Sign In"
#
#    # Now lets follow that sign in link
#    click_link "Sign In"
#
#    # Make sure we're on the sign in page
#    assert_equal current_path, new_user_session_path
#
#    # Make sure there is a forgot password link
#    assert page.has_link? "Forgot password?"

    # Click on the forgot password link
  end

  # Story: A user wants to log into the site and change their password
  # because they think they current password needs to be stronger.
  test "change password" do
  end
end
