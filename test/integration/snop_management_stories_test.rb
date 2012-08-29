require 'test_helper'

# Tests user stories pertaining to snop management
class SnopManagementStoriesTest < ActionDispatch::IntegrationTest

  # Story: A user comes to snopsize.com, logs in, and creates
  # a new snop.
  test "log in and create a snop" do
    # Go to home page
    visit('/')
    assert_equal root_path, current_path

    # There should be a link to sign-up
    assert page.has_link? "Sign In", href: new_user_session_path

    # Now lets follow that sign in link
    click_link "Sign In"

    # Make sure we're on the sign in page
    wait_until { current_path == new_user_session_path }

    # Sign in
    user = User.create(username: "user1", password: "pass1234", email: "test@email.com")
    user.confirm!
    user.save!

    fill_in "Username", :with => user.username
    fill_in "Password", :with => user.password
    click_button "Sign in"

    # We should now be back on the home page and logged in
    wait_until { current_path == root_path }

    # Let's make sure that the user can see that they're logged in at the top
    assert page.has_link? user.username

    # Let's now follow that link
    click_link user.username

    # We should now be on the user page
    wait_until { current_path == user_path(user) }

    # The user see's the new snop button, and wants to create a new snop
    click_link "New Snop"

    # We should now be on new snop page
    wait_until { current_path == new_snop_path }

    # Let's fill in some fields for a user to create a snop
    fill_in('Title', with: "My Snop Title")
    fill_in('Uri', with: "www.myfakeuri.com/article/2103")
    fill_in('Point1', with: "My First Point")
    fill_in('Point2', with: "My Second Point")
    fill_in('Point3', with: "My Third Point")
    fill_in('Summary', with: "My Summary")
    click_button "Create Snop"

    # The user should now be shown the snop they just created
    wait_until { current_path == user_path(user) }
  end

  test "create a snop from a resource page" do
    # Go to home page
    visit('/')
    assert_equal root_path, current_path

    # There should be a link to sign-up
    assert page.has_link? "Sign In", href: new_user_session_path

    # Now lets follow that sign in link
    click_link "Sign In"

    # Make sure we're on the sign in page
    wait_until { current_path == new_user_session_path }

    # Sign in
    user = User.create(username: "user1", password: "pass1234", email: "test@email.com")
    user.confirm!
    user.save!

    fill_in "Username", :with => user.username
    fill_in "Password", :with => user.password
    click_button "Sign in"

    # We should now be back on the home page and logged in
    wait_until { current_path == root_path }

    # The snop should be there
    assert has_link?(snops(:one).title)

    # Click on the snop
    click_link(snops(:one).title)

    # We should now be on snop page
    wait_until { current_path == root_path }

    # Click to see all the other snops for that resource
    url = snops(:one).domain.uri + snops(:one).resource.uri
    click_link("See all snops for article " + url)

    # We should now be on a resource page
    wait_until { current_path == resource_path(domain_id: snops(:one).domain.id, resource_id: snops(:one).resource.id) }

    # Click to snop about that URL
    click_link("Snop about " + url)

    # The URI field should be filled in with
    assert_equal find_field('Uri').value, url

    # Let's fill in some fields for a user to create a snop
    fill_in('Title', with: "My Snop Title")
    fill_in('Point1', with: "My First Point")
    fill_in('Point2', with: "My Second Point")
    fill_in('Point3', with: "My Third Point")
    fill_in('Summary', with: "My Summary")
    click_button "Create Snop"

    # The user should now be shown the snop they just created
    wait_until { current_path == resource_path(domain_id: snops(:one).domain.id, resource_id: snops(:one).resource.id) }
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
    # Go to home page
    visit('/')
    assert_equal current_path, root_path

    # There should be a link to sign-up
    assert page.has_link? "Sign In", href: new_user_session_path

    # Now lets follow that sign in link
    click_link "Sign In"

    # Make sure we're on the sign in page
    wait_until { current_path == new_user_session_path }

    # Sign in
    user = User.create(username: "user1", password: "pass1234", email: "test@email.com")
    user.confirm!
    user.save!

    fill_in "Username", :with => user.username
    fill_in "Password", :with => user.password
    click_button "Sign in"

    # We should now be back on the home page and logged in
    assert_equal root_path, current_path

    # Now the user want's to click on a snop
    click_link(snops(:one).title)

    # We should be on the snop page now
    assert_equal root_path, current_path

    # They see a favourite button there, they like the snop so they will favourite it
    click_button("Favourite")

    # We should be on the snop page still
    assert_equal root_path, current_path

    # The button should change to "Unfavourite"
    assert page.has_button?("Unfavourite")

    # Now the user goes to their home page
    click_link(user.username)

    # Give it some time to make it to the page
    wait_until(5) do
      current_path == user_path(user)
    end

    # Make sure we're on the user page now
    assert_equal current_path, user_path(user)

    # They should now see a link to their favourite snop in their snops
    assert page.has_link?(snops(:one).title)
  end

  # Story: A user is looking through their snops and finds one that 
  # they don't think is good anymore (an old favourite). They now want
  # to remove it from their favourite list.
  test "unfavouriting a snop" do
    # Go to home page
    visit('/')
    assert_equal root_path, current_path

    # There should be a link to sign-up
    assert page.has_link? "Sign In", href: new_user_session_path

    # Now lets follow that sign in link
    click_link "Sign In"

    # Make sure we're on the sign in page
    wait_until { current_path == new_user_session_path }

    # Sign in
    user = User.create(username: "user1", password: "pass1234", email: "test@email.com")
    user.confirm!
    user.save!

    fill_in "Username", :with => user.username
    fill_in "Password", :with => user.password
    click_button "Sign in"

    # We should now be back on the home page and logged in
    wait_until { current_path == root_path }

    # Now the user want's to click on a snop
    click_link(snops(:one).title)

    # We should be on the snop page now
    wait_until { current_path == root_path }

    # They see a favourite button there, they like the snop so they will favourite it
    click_button("Favourite")

    # We should be on the snop page still
    wait_until { current_path == root_path }

    # The button should change to "Unfavourite"
    assert page.has_button?("Unfavourite")

    # Now the user goes to their home page
    click_link(user.username)

    # Make sure we're on the user page now
    wait_until { current_path == user_path(user) }

    # They should now see a link to their favourite snop in their snops
    assert page.has_link?(snops(:one).title)

    # But they changed their mind, now they want to unfavourite
    # So they click the snop to bring it up in the snop column
    click_link(snops(:one).title)

    # Make sure it's displayed
    assert page.has_content?(snops(:one).title)

    # Make sure the button says unfavourite
    assert page.has_button?("Unfavourite")

    # click it
    click_button("Unfavourite")

    # The page should no longer have a link to the snop
    wait_until { !page.has_link?(snops(:one).title) }

    # And the snop should no longer be showing    
    wait_until { !page.has_content?(snops(:one).title) }
  end
end
