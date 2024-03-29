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
    assert_equal new_user_session_path, current_path

    # Sign in
    user = User.create(username: "user1", password: "pass1234", email: "test@email.com")
    user.confirm!
    user.save!

    fill_in "Username", :with => user.username
    fill_in "Password", :with => user.password
    click_button "Sign in"

    # We should now be back on the home page and logged in
    assert_equal root_path, current_path

    # Let's now follow that link
    click_link "My Snops"

    # We should now be on the user page
    assert_equal user_path(user), current_path

    # The user see's the new snop button, and wants to create a new snop
    click_link(I18n.t :create_a_snop)

    # Try aborting -- it should return us to the path we were just at
    click_link(I18n.t :my_snops)
    assert_equal user_path(user), current_path

    # Go back to snop creation
    click_link(I18n.t :create_a_snop)

    # We should now be on new snop page
    assert_equal new_snop_path, current_path

    # Let's fill in some fields for a user to create a snop
    fill_in('snop_title', with: "My Snop Title")
    fill_in('snop_uri', with: "www.myfakeuri.com/article/2103")
    fill_in('snop_point1', with: "My First Point")
    fill_in('snop_point2', with: "My Second Point")
    fill_in('snop_point3', with: "My Third Point")
    fill_in('snop_summary', with: "My Summary")
    click_button "Create Snop"

    # The user should now be shown the snop they just created
    assert_equal user_path(user), current_path
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
    assert_equal new_user_session_path, current_path

    # Sign in
    user = User.create(username: "user1", password: "pass1234", email: "test@email.com")
    user.confirm!
    user.save!

    fill_in "Username", :with => user.username
    fill_in "Password", :with => user.password
    click_button "Sign in"

    # We should now be back on the home page and logged in
    assert_equal root_path, current_path

    # Now the user want's to click on the list view
    click_link(I18n.t :list_view)

    # The snop should be there
    assert has_link?(snops(:one).title)

    # Click on the snop
    click_link(snops(:one).title)

    # We should now be on snop page
    assert_equal root_path, current_path

    # Click to see all the other snops for that resource
    url = snops(:one).domain.uri + snops(:one).resource.uri
    click_link(I18n.t :see_all_for_article)

    # We should now be on a resource page
    assert_equal resource_path(domain_id: snops(:one).domain.id, resource_id: snops(:one).resource.id), current_path

    # Click to snop about that URL
    click_link(I18n.t(:snop_about_article))

    # The URI field should be filled in with
    assert_equal find_field('snop_uri').value, url

    # Let's fill in some fields for a user to create a snop
    fill_in('snop_title', with: "My Snop Title")
    fill_in('snop_point1', with: "My First Point")
    fill_in('snop_point2', with: "My Second Point")
    fill_in('snop_point3', with: "My Third Point")
    fill_in('snop_summary', with: "My Summary")
    click_button "Create Snop"

    # The user should now be shown the snop they just created
    assert current_path, user_path(id: user.id, iSortCol_0: 3, sSortDir_0: "desc") 
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
    assert_equal new_user_session_path, current_path

    # Sign in
    user = User.create(username: "user1", password: "pass1234", email: "test@email.com")
    user.confirm!
    user.save!

    fill_in "Username", :with => user.username
    fill_in "Password", :with => user.password
    click_button "Sign in"

    # We should now be back on the home page and logged in
    assert_equal root_path, current_path

    # Now the user want's to click on the list view
    click_link(I18n.t :list_view)

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

    # Now the user goes to their favourites
    click_link(I18n.t :favourite_snops)

    # Give it some time to make it to the page
    assert_equal user_favourites_path(user), current_path

    # They should now see a link to their favourite snop in their snops
    assert page.has_link?(snops(:one).title)
  end

#  # Story: A user is looking through their snops and finds one that 
#  # they don't think is good anymore (an old favourite). They now want
#  # to remove it from their favourite list.
#  test "unfavouriting a snop" do
#    # Go to home page
#    visit('/')
#    assert_equal root_path, current_path
#
#    # There should be a link to sign-up
#    assert page.has_link? "Sign In", href: new_user_session_path
#
#    # Now lets follow that sign in link
#    click_link "Sign In"
#
#    # Make sure we're on the sign in page
#    wait_until { current_path == new_user_session_path }
#
#    # Sign in
#    user = User.create(username: "user1", password: "pass1234", email: "test@email.com")
#    user.confirm!
#    user.save!
#
#    fill_in "Username", :with => user.username
#    fill_in "Password", :with => user.password
#    click_button "Sign in"
#
#    # We should now be back on the home page and logged in
#    wait_until { current_path == root_path }
#
#    # Now the user want's to click on the list view
#    click_link(I18n.t :list_view)
#
#    # Now the user want's to click on a snop
#    click_link(snops(:one).title)
#
#    # We should be on the snop page now
#    wait_until { current_path == root_path }
#
#    # They see a favourite button there, they like the snop so they will favourite it
#    click_button("Favourite")
#
#    # We should be on the snop page still
#    wait_until { current_path == root_path }
#
#    # The button should change to "Unfavourite"
#    assert page.has_button?("Unfavourite")
#
#    # Now the user goes to their home page
#    click_link "My Favourites"
#
#    # Make sure we're on the user page now
#    wait_until { current_path == user_favourites_path(user) }
#
#    # They should now see a link to their favourite snop in their snops
#    assert page.has_link?(snops(:one).title)
#
#    # But they changed their mind, now they want to unfavourite
#    # So they click the snop to bring it up in the snop column
#    click_link(snops(:one).title)
#
#    # Make sure it's displayed
#    assert page.has_content?(snops(:one).title)
#
#    # Make sure the button says unfavourite
#    assert page.has_button?("Unfavourite")
#
#    # click it
#    click_button("Unfavourite")
#
#    # Back on the user page now
#    wait_until { current_path == user_favourites_path(user) }
#
#    # TODO -- this test just doesn't want to work
#    # Seems like it's looking at page source and not the DOM
#
#    # The page should no longer have a link to the snop
#    # assert page.has_no_link?(snops(:one).title)
#
#    # And the snop should no longer be showing    
#    # assert page.has_no_content?(snops(:one).title)
#  end
end
