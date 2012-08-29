module UserHelper
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
end
