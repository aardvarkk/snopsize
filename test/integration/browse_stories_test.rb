require 'test_helper'

# tests the user stories for a user browsing the website
class BrowseStoriesTest < ActionDispatch::IntegrationTest
  # Story: A user comes to snopsize.com, and see an article they are interested in.
  # They follow a link to see all snops for that article
  test "browsing resource snops" do
    # Go to home page
    visit('/')
    assert_equal current_path, root_path

    # On the home page they see a snop, they click on the title
    click_link snops(:one).title
    assert_equal current_path, snop_path(snops(:one))

    # They now see the snop, but what they really want is to see
    # All the snops for that article, so they click on the link
    click_link ("See all snops for article " + snops(:one).domain.uri + snops(:one).resource.uri)
    assert_equal current_path, resource_path(domain_id: snops(:one).domain.id, resource_id: snops(:one).resource.id)

    # TODO: Once we add some AJAX here, we should probably test that you can
    # switch between snops for a resource
  end

  # Story: A user comes to snopsize.com, and sees a link to a website they think
  # has interesting stories. They follow a link to see all the articles that have
  # been snopped for that website.
  test "browsing domains" do
    # Go to home page
    visit('/')
    assert_equal current_path, root_path

    # On the home page they see a snop, they click on the title
    click_link snops(:one).title
    assert_equal current_path, snop_path(snops(:one).id)

    # They now see the snop, but what they really want is to see
    # All the articles for that particular website, so they click on a domain
    click_link ("Other posts from " + snops(:one).domain.uri)
    assert_equal current_path, domain_path(snops(:one).domain)
  end

  # Story: A user seems a few snops from a user they like, they want to see all the
  # snops from that user
  test "browsing user snops" do
    # Go to home page
    visit('/')
    assert_equal current_path, root_path

    # On the home page they see a user who's snops they've seen before.
    # They want to see other snops from that user
    click_link snops(:one).user.username
    assert_equal current_path, user_path(snops(:one).user)

    # TODO: Once we add some AJAX here, we should probably test that you can
    # switch between snops for a user, click on categories, etc.
  end
end
