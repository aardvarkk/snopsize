require 'test_helper'

# Tests the User Stories related to snopsize.com social media
class SocialMediaStoriesTest < ActionDispatch::IntegrationTest

  setup do
    # Switch to selenium for this test since we have JS to execute
    Capybara.current_driver = :selenium
  end

  # Story: A user has found a snop that they think is particularily 
  # good, and they want to share it on twitter.
  test "tweet a snop from snop page" do
    # Go to home page
    visit('/')
    assert_equal current_path, root_path

    # There should be a link to sign-in
    assert page.has_link? "Sign In", href: new_auth_session_path

    # Now lets follow that sign in link
    click_link "Sign In"

    # Make sure we're on the sign in page
    assert_equal current_path, new_auth_session_path

    # Sign in
    user = User.create(username: "user1", password: "pass1234", email: "test@email.com")
    user.confirm!
    user.save!

    fill_in "Username", :with => user.username
    fill_in "Password", :with => user.password
    click_button "Sign in"

    # We should now be back on the home page and logged in
    assert_equal current_path, root_path

    # Now the user want's to click on a snop
    click_link(snops(:one).title)

    # We should be on the snop page now
    assert_equal root_path, current_path

    # TODO: Capybara can't seem to find the tweet button
    # Can't figure out how to do this...
  end

  # Story: A user has found a snop that they think is particularily
  # good, and they want to "Like" the snop on Facebook from the snop page
  test "facebook like a snop from snop page" do
    # Go to home page
    visit('/')
    assert_equal current_path, root_path

    # There should be a link to sign-in
    assert page.has_link? "Sign In", href: new_auth_session_path

    # Now lets follow that sign in link
    click_link "Sign In"

    # Make sure we're on the sign in page
    assert_equal current_path, new_auth_session_path

    # Sign in
    user = User.create(username: "user1", password: "pass1234", email: "test@email.com")
    user.confirm!
    user.save!

    fill_in "Username", :with => user.username
    fill_in "Password", :with => user.password
    click_button "Sign in"

    # We should now be back on the home page and logged in
    assert_equal current_path, root_path

    # Now the user want's to click on a snop
    click_link(snops(:one).title)

    # We should be on the snop page now
    assert_equal root_path, current_path

    # TODO: Capybara can't seem to find the like button
    # Can't figure out how to do this...
  end

  # Story: A user is browsing snops on the user page and sees
  # one that they want to like on facebook
  test "facebook like a snop from user page" do
  end

  # Story: A user is browsing snops on the user page and sees
  # one that they want to tweet
  test "tweet a snop from user page" do
  end

  # Story: A user is browsing snops on the resource page and sees
  # one that they want to like on facebook
  test "facebook like a snop from resource page" do
  end

  # Story: A user is browsing snops on the resource page and sees
  # one that they want to tweet
  test "tweet a snop from resource page" do
  end
end
