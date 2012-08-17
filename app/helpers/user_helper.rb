module UserHelper
  def recurse_categorized_snops(categories, &block)
  	categories.each do |category|
  	  # yield to the caller to do whatever with the snops for the category
  	  yield(category.snops, category)
  	
  	  # recurse on each child of the category
  	  recurse_categorized_snops(category.children, &block) 
  	end
  end

  # Retrieves list of created and faved snops for a user
  def get_all_snops_for_user(user)
    # Get a list of all the users created snops
    # (i.e. snops created by the user)
    user_snops = user.snops.where(deleted: false)

    # Get the list of favourte snops
    fave_snops = user.favourites
    
    # Combine them
    # Note that we check this value in testing
    # We want to make sure there are no duplicates within it
    # This could happen if you favourited your own snop
    all_snops = (user_snops + fave_snops).uniq
  end

  # Returns a list of uncategorized snops for a user
  def get_uncategorized_snops_for_user(user)
    # Get all uncategorized snops, and make sure we only
    # get unique ones.
    uncategorized_snops = get_all_snops_for_user(user) - user.categorized_snops
  end

  # Returns a list of categories for a user
  def get_root_categories_for_user(user)    
    # Find a set of "root" categories
    root_categories = user.user_categories.where("parent_id IS ?", nil)
  end

end
