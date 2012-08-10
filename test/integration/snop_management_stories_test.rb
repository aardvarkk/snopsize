require 'test_helper'

# Tests user stories pertaining to snop management
class SnopManagementStoriesTest < ActionDispatch::IntegrationTest

  # Story: A user comes to snopsize.com, logs in, and creates
  # a new snop.
  test "log in and create a snop" do
    # Go to home page
    visit('/')
    assert_equal current_path, root_path

    # There should be a link to sign-up
    assert page.has_link? "Sign In", href: new_user_session_path

    # Now lets follow that sign in link
    click_link "Sign In"

    # Make sure we're on the sign in page
    assert_equal current_path, new_user_session_path

    # Sign in
    user = User.create(username: "user1", password: "pass1234", email: "test@email.com")
    user.save!

    fill_in "Username", :with => user.username
    fill_in "Password", :with => user.password
    click_button "Sign in"

    # We should now be back on the home page and logged in
    assert_equal current_path, root_path

    # Let's make sure that the user can see that they're logged in at the top
    assert page.has_link? user.username

    # Let's now follow that link
    click_link user.username

    # We should now be on the user page
    assert_equal current_path, user_path(user)

    # The user see's the new snop button, and wants to create a new snop
    click_link "New Snop"

    # We should now be on new snop page
    assert_equal current_path, new_snop_path

    # Let's fill in some fields for a user to create a snop
    fill_in('Title', with: "My Snop Title")
    fill_in('Uri', with: "www.myfakeuri.com/article/2103")
    fill_in('Point1', with: "My First Point")
    fill_in('Point2', with: "My Second Point")
    fill_in('Point3', with: "My Third Point")
    fill_in('Summary', with: "My Summary")
    click_button "Create Snop"

    # The user should now be shown the snop they just created
    assert_equal current_path, snop_path(user.snops.first)
  end

  # Story: A user has created a snop that they now think they want to
  # delete. 
  test "delete a snop" do

    # TODO: We don't actually have any way to delete snops from a users
    # point of view right now, we'll have to come back to this.

  end

  # Story: A user is browsing through snops and finds one they like, 
  # they would like to mark it as a favourite of theirs.
  test "favouriting a snop" do
    # Switch to selenium for this test since we have JS to execute
    Capybara.current_driver = :selenium

    # Go to home page
    visit('/')
    assert_equal current_path, root_path

    # There should be a link to sign-up
    assert page.has_link? "Sign In", href: new_user_session_path

    # Now lets follow that sign in link
    click_link "Sign In"

    # Make sure we're on the sign in page
    assert_equal current_path, new_user_session_path

    # Sign in
    user = User.create(username: "user1", password: "pass1234", email: "test@email.com")
    user.save!

    fill_in "Username", :with => user.username
    fill_in "Password", :with => user.password
    click_button "Sign in"

    # We should now be back on the home page and logged in
    assert_equal current_path, root_path

    # Now the user want's to click on a snop
    click_link(snops(:one).title)

    # We should be on the snop page now
    assert_equal current_path, snop_path(snops(:one))

    # They see a favourite button there, they like the snop so they will favourite it
    click_button("Favourite")

    # We should be on the snop page still
    assert_equal current_path, snop_path(snops(:one))

    # The button should change to "Unfavourite"
    assert page.has_button?("Unfavourite")

    # Now the user goes to their home page
    click_link(user.username)

    # Give it some time to make it to the page
    sleep 2

    # Make sure we're on the user page now
    assert_equal current_path, user_path(user)

    # They should now see a link to their favourite snop in their snops
    assert page.has_link?(snops(:one).title)
  end

  # Story: A user is looking through their snops and finds one that 
  # they don't think is good anymore (an old favourite). They now want
  # to remove it from their favourite list.
  test "unfavouriting a snop" do
    # Switch to selenium for this test since we have JS to execute
    Capybara.current_driver = :selenium

    # Go to home page
    visit('/')
    assert_equal current_path, root_path

    # There should be a link to sign-up
    assert page.has_link? "Sign In", href: new_user_session_path

    # Now lets follow that sign in link
    click_link "Sign In"

    # Make sure we're on the sign in page
    assert_equal current_path, new_user_session_path

    # Sign in
    user = User.create(username: "user1", password: "pass1234", email: "test@email.com")
    user.save!

    fill_in "Username", :with => user.username
    fill_in "Password", :with => user.password
    click_button "Sign in"

    # We should now be back on the home page and logged in
    assert_equal current_path, root_path

    # Now the user want's to click on a snop
    click_link(snops(:one).title)

    # We should be on the snop page now
    assert_equal current_path, snop_path(snops(:one))

    # They see a favourite button there, they like the snop so they will favourite it
    click_button("Favourite")

    # We should be on the snop page still
    assert_equal current_path, snop_path(snops(:one))

    # The button should change to "Unfavourite"
    assert page.has_button?("Unfavourite")

    # Now the user goes to their home page
    click_link(user.username)

    # Give it some time to make it to the page
    sleep 2

    # Make sure we're on the user page now
    assert_equal current_path, user_path(user)

    # They should now see a link to their favourite snop in their snops
    assert page.has_link?(snops(:one).title)

    # But they changed their mind, now they want to unfavourite
    click_link(snops(:one).title)

    # Back to the snop page
    assert_equal current_path, snop_path(snops(:one))

    # Make sure it still says Unfavourite
    assert page.has_button?("Unfavourite");

    # click it
    click_button("Unfavourite")

    # The button should change to "Unfavourite"
    assert page.has_button?("Favourite")

    # Now let's go back to the home page   
    click_link(user.username)

    # Give it some time to make it to the page
    sleep 2

    # Make sure we're on the user page now
    assert_equal current_path, user_path(user)

    # They shouldn't have the snop in there anymore
    assert !page.has_link?(snops(:one).title)
  end
end
