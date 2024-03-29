require 'test_helper'

class SnopTest < ActiveSupport::TestCase

  # Each snop has a mandatory user_id
  test "mandatory fields" do
    # Can't create without user/title
    snop = Snop.new
    assert !snop.save, "Saved snop without user or title!"

    # Can't create without title
    snop = Snop.new
    snop.user_id = 0
    assert !snop.save, "Saved snop without title!"

    # Can't create without user
    snop = Snop.new
    snop.title = "Snop!"
    assert !snop.save, "Saved snop without user!"

    # Need at a minimum both user and title!
    snop = Snop.new
    snop.user_id = users(:one).id;
    snop.title = "Snop!"
    assert snop.save, "Can't save snop!"
  end

  # Snops can't be edited once they're created
  test "no editing" do
    snop = snops(:one)
    snop.user = users(:one)
    old_title = snop.title
    assert_not_nil snop, "Can't find object from fixture"

    # now we try to edit title, it should fail
    snop.title = "New Title!"
    snop.save! # Interestingly, you can stll save the snop, but it wont take in the DB
    snop.reload # This loads back the original value since it was never changed!
    assert_equal snop.title, old_title, "Was able to change the title!"

    # A different way to update, should raise an error
    assert_raises(ActiveRecord::ActiveRecordError) do
      snop.update_column(:title, "NEW TITLE!") 
    end

    # now lets try to update the.... user id
    snop.user_id = 10
    assert_raises(ActiveRecord::RecordInvalid) { snop.save! }
    
    # A different way to update, should raise an error.
    # Let's try with a different field.... how about summary
    assert_raises(ActiveRecord::ActiveRecordError) do
      snop.update_column(:summary, "My NEW SUMMARY!!") 
    end

    # Let's try a 3rd way to update
    snop.update_attributes({:point1 => "New point!"})
    snop.reload
    assert_not_equal snop.point1, "New point!", "Was able to change the point!"
  end

  # Snops can be deleted however
  test "deletion" do
    # Create a snop, then we'll delete it
    snop = Snop.new
    snop.user_id = users(:one).id;
    snop.title = "Title!";
    assert snop.save, "Can't save snop!"
    assert snop.delete, "Can't delete snop!"
  end

  # We want to make sure that any snop we create, has a valid user
  test "valid user" do
    snop = Snop.new(
      :user_id => users(:one).id, 
      :title => "My Title!"
      )
    assert snop.save, "Unable to save with valid user!"

    invalid_snop = Snop.new(
      :user_id => 243, 
      :title => "A Title"
      )
    assert !invalid_snop.save, "Saved with invalid user!"
  end 

  # We want to make sure that the URI is valid
  test "valid uri" do
    
    # Blank URI
    snop = Snop.new(
      :user_id => users(:one).id, 
      :title => "My Title!",
      :uri => nil
      )
    assert snop.save, "Unable to save with a blank URI."

    # Try something that's not even a URI
    snop = Snop.new(
      :user_id => users(:one).id, 
      :title => "My Title!",
      :uri => "I'm not even a uri!"
      )
    assert !snop.save, "Saved with something that's not even a URI."

    # Try something with an invalid public suffix
    snop = Snop.new(
      :user_id => users(:one).id, 
      :title => "My Title!",
      :uri => "http://www.google.aaa"
      )
    assert !snop.save, "Saved with an invalid public suffix."

    # Try something with no host
    snop = Snop.new(
      :user_id => users(:one).id, 
      :title => "My Title!",
      :uri => "http://"
      )
    assert !snop.save, "Saved with no host."

    # Try something not http
    snop = Snop.new(
      :user_id => users(:one).id, 
      :title => "My Title!",
      :uri => "ftp://www.google.com"
      )
    assert !snop.save, "Saved with an invalid scheme."

    # Try something https (not currently accepted?)
    snop = Snop.new(
      :user_id => users(:one).id, 
      :title => "My Title!",
      :uri => "https://www.google.com"
      )
    assert snop.save, "Couldn't save with an https scheme."

    # Now let's pass in a valid URI
    snop = Snop.new(
      :user_id => users(:one).id, 
      :title => "My Title!",
      :uri => "http://www.theglobeandmail.com/sports/olympics/canadian-team-advances-after-badminton-players-expelled-from-olympics-for-match-throwing/article4453784/"
      )
    assert snop.save, "Unable to save snop with valid URI."

    # This is (unfortunately) a "valid" URI even though the site doesn't exist
    snop = Snop.new(
      :user_id => users(:one).id, 
      :title => "My Title!",
      :uri => "http://www.fakeuri.uri.com"
      )
    assert snop.save, "Unable to save snop with semi-valid URI."

    # Try something that doesn't have domain and resource
    snop = Snop.new(
      :user_id => users(:one).id, 
      :title => "My Title!",
      :uri => "www.theglobeandmail.com"
      )
    assert snop.save, "Unable to save a domain-only snop missing http://."

    # Try something that doesn't have domain and resource
    snop = Snop.new(
      :user_id => users(:one).id, 
      :title => "My Title!",
      :uri => "http://theglobeandmail.com"
      )
    assert snop.save, "Unable to save a domain-only snop missing www."

  end

  # Make sure all the text based snop fields are of the proper length
  # I.e. not longer than 256 chars
  test "field lengths" do
    # Make sure title is not too long
    snop = Snop.new(
      :user_id => users(:one).id, 
      :title => "My Title!" * 100
      )
    assert !snop.save, "Saved with title longer than 256 chars"

    # Make sure point1 is not too long
    snop = Snop.new(
      :user_id => users(:one).id, 
      :title => "My Title!",
      :point1 => "Point1!!" * 32
      )
    assert snop.save, "Unable to save with exactly 256 chars"

    snop = Snop.new(
      :user_id => users(:one).id, 
      :title => "My Title!",
      :point1 => "Point1!!" * 33
      )
    assert !snop.save, "Saved with point1 longer than 256 chars"

    # Make sure point2 is not too long
    snop = Snop.new(
      :user_id => users(:one).id, 
      :title => "My Title!",
      :point2 => "Point2!!" * 45
      )
    assert !snop.save, "Saved with point2 longer than 256 chars"

    # Make sure point3 is not too long
    snop = Snop.new(
      :user_id => users(:one).id, 
      :title => "My Title!",
      :point3 => "Point3!!" * 89
      )
    assert !snop.save, "Saved with point3 longer than 256 chars"

    # Make sure summary is not too long
    snop = Snop.new(
      :user_id => users(:one).id, 
      :title => "My Title!",
      :summary => "Summary!!" * 133
      )
    assert !snop.save, "Saved with summary longer than 256 chars"
  end

end
