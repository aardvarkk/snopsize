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
    snop = Snop.create(title: "My Snop Title", point1: "My First Point", point2: "My Second Point", point3: "My Third Point" , summary: "My Summary", uri: "www.myfakeuri.com/article/2103")
    snop.save!

    fill_in('Title', with: snop.title)
    fill_in('Uri', with: snop.uri)
    fill_in('Point1', with: snop.point1)
    fill_in('Point2', with: snop.point2)
    fill_in('Point3', with: snop.point3)
    fill_in('Summary', with: snop.summary)
    click_button "Create Snop"

    # The user should now be shown the snop they just created
    assert_equal current_path, snop_path(snop)
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
  end

  # Story: A user is looking through their snops and finds one that 
  # they don't think is good anymore (an old favourite). They now want
  # to remove it from their favourite list.
  test "unfavouriting a snop" do
  end
end
