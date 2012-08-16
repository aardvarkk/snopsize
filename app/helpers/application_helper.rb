module ApplicationHelper
  # Get the snop content in single string for passed in snop.
  def get_snop_content(snop)
    # Create a tweetable string by combining title, all points, and summary
    # For now, we'll just put a space in between them all.
    snopcontent = snop.title
    snopcontent += ' ' + snop.point1 if snop.point1
    snopcontent += ' ' + snop.point2 if snop.point2
    snopcontent += ' ' + snop.point3 if snop.point3
    snopcontent += ' ' + snop.summary if snop.summary
    snopcontent.truncate(140)
  end

  # Has the current user favourited the passed in snop?
  def has_user_faved_snop?(snop)
    # has the logged in user already faved this snop?
    fave_snop = current_user.favourites.find_by_id(@snop.id) if user_signed_in?
    fave_snop.nil?
  end
end
