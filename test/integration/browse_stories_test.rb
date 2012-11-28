require 'test_helper'

# tests the user stories for a user browsing the website
class BrowseStoriesTest < ActionDispatch::IntegrationTest
  # Story: A user comes to snopsize.com, and see an article they are interested in.
  # They follow a link to see all snops for that article
  test "browsing resource snops" do
    # Go to home page
    visit('/')
    assert_equal current_path, root_path

    # Now the user want's to click on the list view
    click_link(I18n.t :list_view)

    # On the home page they see a snop, they click on the title
    click_link snops(:one).title
    assert_equal root_path, current_path

    # They now see the snop, but what they really want is to see
    # All the snops for that article, so they click on the link
    click_link(I18n.t :see_all_for_article)

    # Wait until we get to the resource page
    assert_equal resource_path(domain_id: snops(:one).domain.id, resource_id: snops(:one).resource.id), current_path

    # Now the user want's to click on the list view
    click_link(I18n.t :list_view)

    # make sure we see the other snop now
    assert has_link?(snops(:four).title)
    click_link(snops(:four).title)

    # Let's switch between some snops, let's go to the next snop
    find('.arrow.next').click

    # make sure we see the other snop now
    assert has_content?(snops(:one).title)

    # now lets go back
    find('.arrow.prev').click

    # we should now be back to snop 1 being shown
    assert has_content?(snops(:four).title)
  end

  # Story: A user comes to snopsize.com, and sees a link to a website they think
  # has interesting stories. They follow a link to see all the articles that have
  # been snopped for that website.
  test "browsing domains" do
    # Go to home page
    visit('/')
    assert_equal current_path, root_path

    # Now the user want's to click on the list view
    click_link(I18n.t :list_view)

    # On the home page they see a snop, they click on the title
    click_link snops(:one).title
    assert_equal root_path, current_path

    # They now see the snop, but what they really want is to see
    # All the articles for that particular website, so they click on a domain
    click_link snops(:one).domain.uri
    assert_equal domain_path(snops(:one).domain), current_path
  end

  # Story: A user sees a few snops from a user they like, they want to see all the
  # snops from that user
  test "browsing user snops" do
    # Go to home page
    visit('/')
    assert_equal root_path, current_path

    # Now the user want's to click on the list view
    click_link(I18n.t :list_view)

    # Click on the snop name in the list view to transfer back to browse view
    click_link snops(:one).title

    # On the home page they see a user who's snops they've seen before.
    # They want to see other snops from that user
    click_link snops(:one).user.username
    assert_equal user_path(snops(:one).user), current_path

    # TODO: Once we add some AJAX here, we should probably test that you can
    # switch between snops for a user, click on categories, etc.
  end
end
