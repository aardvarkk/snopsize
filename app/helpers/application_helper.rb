module ApplicationHelper

  # Get tweet content in single string for passed in snop.
  def get_snop_tweet_content(snop)
    
    # get the allowable length for the title, which will be:
    # 140 - length of hashtag - length of link - length of spaces (2)
    # the link length of 19 comes from twitter's auto-shortening

    # Assuming only a hashtag -- the hashtag itself minus a space and a # char
    title_len = 140 - I18n.t(:snopsize_hashtag).length - 2

    # If there's a link...
    # Subtract another 20 for the link length and 1 for the space before
    if snop.domain and snop.resource
      title_len -= 21;
    end

    # Create a tweetable string by combining title, all points, and summary
    # For now, we'll just put a space in between them all.
    snopcontent = snop.title.truncate(title_len);

    # Add a URL if there is one
    if snop.domain and snop.resource
      snopcontent += " " + snop.domain.uri + snop.resource.uri
    end

    return snopcontent
    
  end

  # Has the current user favourited the passed in snop?
  def has_user_faved_snop?(snop)
    # has the logged in user already faved this snop?
    fave_snop = current_user.favourites.find_by_id(snop.id) if user_signed_in?
    fave_snop.nil?
  end

  def snop_has_next_in_list?(snop, snop_list)
    # Can't have a next if stuff is nil
    return false if snop.nil? || snop_list.nil? || snop_list.empty?

    # get index of snop inside list   
    snop_index = snop_list.index(snop)
    return false if snop_index.nil?

    if snop_index < snop_list.size - 1
      return true
    else
      return false
    end
  end

  def snop_has_prev_in_list?(snop, snop_list)
    # Can't have a next if stuff is nil
    return false if snop.nil? || snop_list.nil? || snop_list.empty?

    # get index of snop inside list   
    snop_index = snop_list.index(snop)
    return false if snop_index.nil?

    if snop_index > 0
      return true
    else
      return false
    end
  end

  def snop_get_next_in_list(snop, snop_list)
    # get index of snop inside list   
    snop_index = snop_list.index(snop)

    # Get the next snop
    snop_list[snop_index + 1] if snop_has_next_in_list?(snop, snop_list)
  end

  def snop_get_prev_in_list(snop, snop_list)
    # get index of snop inside list   
    snop_index = snop_list.index(snop)

    # Get the previous snop
    snop_list[snop_index - 1] if snop_has_prev_in_list?(snop, snop_list)
  end
end
