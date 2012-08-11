require 'test_helper'

# Tests user stories for search
class SearchStoriesTest < ActionDispatch::IntegrationTest
  # This is the only workaround I could find for indexing the 
  # test database so that they would be seen during the test
  setup do
    Snop.reindex
    #User.reindex
    #Resource.reindex
    #Domain.reindex
  end

  # Story: The user remembers a user that they think has really good
  # snops, so they decide to search for that user and find their snops.
  test "search for a user" do    
    # Go to home page
    visit('/')
    assert_equal current_path, root_path

    # On the home page they see a user, so they search for the username
    # First they select user from the drop down
    select("User", from: "type")
    # Then they type in the username
    fill_in("Search for:", with: users(:one).username)
    click_button "Search"

    # We should now be on the search page
    assert_equal current_path, search_path

    # There should be a result with the username
    assert has_link?(users(:one).username)

    # The user then clicks on the username
    click_link users(:one).username

    # And they are now on the user page where they can browse all the
    # users snops
    assert_equal current_path, user_path(users(:one))
  end

  # Story: The user has found a snop from a website that they think
  # has really interesting articles. They want to search for all snops
  # that pertain to that particular website
  test "search for a domain" do
    # Go to home page
    visit('/')
    assert_equal current_path, root_path

    # The user figures they want to see all snops from a particular
    # website. So they decide they'll search for it
    # First they select URL from the drop down
    select("URL", from: "type")
    # Then they type in the URL
    fill_in("Search for:", with: domains(:one).uri)
    click_button "Search"

    # We should now be on the domain page. The search is smart enough
    # to take us there directly.
    # The user can now see all the articles that have been snopped about
    # from that domain.
    assert_equal current_path, domain_path(domains(:one))
  end

  # Story: The user has found a snop that points to an article they are
  # very interested in. The user wants to see what other snops exist for 
  # that particular article. The user searches for that article link.
  test "search for a resource" do
    # Go to home page
    visit('/')
    assert_equal current_path, root_path

    # The user figures they want to search for a specific article...
    # First they select URL from the drop down
    select("URL", from: "type")
    # Then they type in the article url
    fill_in("Search for:", with: snops(:one).uri)
    click_button "Search"

    # And they are now on the resource page where they can see all the snops
    # for the article they searched for.
    assert_equal current_path, resource_path(domain_id: resources(:one).domain.id, resource_id: resources(:one).id)
  end

  # Story: The user remembers that once before they read a snop about
  # something really interesting. They can't remember who the snop was
  # by or where the article was located, but they remember some part
  # of the text that was in the snop. They want to search for the text
  # that they remember
  test "search for snop text" do
    # Go to home page
    visit('/')
    assert_equal current_path, root_path

    # The user remembers the title of a snop they read before, so they
    # want to search for it
    # Keyword should already be selected
    select("Keyword", from: "type")
    # Then they type in the text they remember
    fill_in("Search for:", with: snops(:one).title)
    click_button "Search"

    # We should now be on the search page
    assert_equal current_path, search_path

    # We should make sure that there is a link on the page to the snop we were searching for
    assert has_link?(snops(:one).title)

    # Click the link and go to the snop
    click_link(snops(:one).title)

    # We should now be on the snop page
    assert_equal current_path, snop_path(snops(:one))
  end
end
