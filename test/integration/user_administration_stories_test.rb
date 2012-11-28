require 'test_helper'

# Tests User Stories for snopsize.com user management
class UserAdministrationStoriesTest < ActionDispatch::IntegrationTest

  # Story: A user comes to snopsize.com and decides they want
  # to create a snopsize account
  test "create account and go to user page" do
    Capybara.current_driver = :rack_test

    # Go to home page
    visit('/')
    assert_equal root_path, current_path

    # There should be a link to sign-up
    assert page.has_link?(I18n.t(:sign_up), href: new_user_registration_path)

    # Now lets follow that sign in link
    click_link I18n.t(:sign_up)

    # Make sure we're on the sign up page
    assert_equal new_user_registration_path, current_path

    # Fill out the sign up form
    fill_in('user_username', with: 'tester')
    fill_in('user_email', with: 'tester@tester.com')
    fill_in('user_password', with: 'tester')
    fill_in('user_password_confirmation', with: 'tester')
    click_button(I18n.t :sign_up)

    # Lets confirm that an email was actually sent!
    assert !ActionMailer::Base.deliveries.empty?
    mail = ActionMailer::Base.deliveries.last
    assert_equal ["tester@tester.com"], mail.to
    assert_equal "Confirmation instructions", mail.subject

    # Let's open up that email
    open_email('tester@tester.com')

    # Click the confirmation link in the email
    assert current_email.has_link? "Confirm my account"
    current_email.click_link "Confirm my account"

    # We should now be back on the home page and logged in
    assert_equal root_path, current_path

    # Let's make sure that the user can see that they're logged in at the top
    assert has_link? "My Snops"

  end

  # Story: A user has forgotten their password when trying to login
  # and wants to reset their password
  test "request password retrieval" do
    Capybara.current_driver = :rack_test

    user = users(:one)

    # Go to home page
    visit('/')
    assert_equal root_path, current_path

    # There should be a link to sign-in
    assert page.has_link? "Sign In", href: new_user_session_path

    # Now lets follow that sign in link
    click_link "Sign In"

    # Make sure we're on the sign in page
    assert_equal new_user_session_path, current_path

    # Make sure there is a forgot password link
    assert page.has_link? "Forgot your password?", href: new_user_password_path

    # Click on the forgot password link
    click_link "Forgot your password?"

    # Make sure we're on the forgot password page
    assert_equal new_user_password_path, current_path

    # Fill in the email field
    fill_in('Email', with: user.email)
    click_button I18n.t :send_reset

    # We are now taken back to the sign in page
    assert_equal new_user_session_path, current_path

    # Lets confirm that an email was actually sent!
    assert !ActionMailer::Base.deliveries.empty?
    mail = ActionMailer::Base.deliveries.last
    assert_equal [user.email], mail.to
    assert_equal "Reset password instructions", mail.subject

    # The user opens up that email they just received and clicks on the link
    open_email(user.email)

    # Click the reset link in the email
    assert current_email.has_link? "Change my password"
    current_email.click_link "Change my password"

    # Now let's actually go the page where the email would send us to
    # reset our password
    assert_equal edit_user_password_path, current_path

    # Let's fill in with a new password
    fill_in('New password', with: "anotherpassword")
    fill_in('Confirm new password', with: "anotherpassword")
    click_button "Change my password"

    # We should now be back on the home page and logged in
    assert_equal root_path, current_path

    # Let's make sure that the user can see that they're logged in at the top
    assert page.has_link? user.username
  end

  # Story: A user wants to log into the site and change their password
  # because they think they current password needs to be stronger.
  test "change password" do
    # TODO: We need to add the edit password page to the website
  end
end
