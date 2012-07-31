require 'test_helper'

class FaveSnopsTest < ActiveSupport::TestCase
  # Foreign keys can't be null
  test "non null foreign keys" do
    # Can't create with no foreign keys
    fave_snop = FaveSnop.new
    assert !fave_snop.save, "Able to save with null foreign keys!"

    # Can't create with no snop_id
    fave_snop = FaveSnop.new
    fave_snop.user_id = users(:one).id
    assert !fave_snop.save, "Saved with no snop_id!"

    # Can't create with no user_id
    fave_snop = FaveSnop.new
    fave_snop.snop_id = snops(:one).id
    assert !fave_snop.save, "Saved with no user_id!"

    # Valid creation
    fave_snop = FaveSnop.new
    fave_snop.user_id = users(:one).id
    fave_snop.snop_id = snops(:one).id
    assert fave_snop.save, "Can't save with valid entries!"
  end

  # We can't favourite a snop more than once for a user
  test "no duplicate favourites" do
    # Valid creation
    fave_snop = FaveSnop.new
    fave_snop.user_id = users(:one).id
    fave_snop.snop_id = snops(:one).id
    assert fave_snop.save, "Can't save with valid entries!" 

    # Try to create a duplicate entry, should fail
    fave_snop = FaveSnop.new
    fave_snop.user_id = users(:one).id
    fave_snop.snop_id = snops(:one).id
    assert !fave_snop.save, "duplicated a favourite!"
  end

  # The user and snop must be valid
  test "valid snop and user" do
    # Can't create a fave snop entry without a valid
    # user and snop

    # Invalid user
    fave_snop = FaveSnop.new
    fave_snop.user_id = 4249
    fave_snop.snop_id = snops(:one).id
    assert !fave_snop.save, "Saved with invalid user"
    
    # Invalid snop
    fave_snop = FaveSnop.new
    fave_snop.user_id = users(:one).id
    fave_snop.snop_id = 245
    assert !fave_snop.save, "Saved with invalid snop"

    # Both valid
    fave_snop = FaveSnop.new
    fave_snop.user_id = users(:one).id
    fave_snop.snop_id = snops(:one).id
    assert fave_snop.save, "Can't save with valid entries!"
  end

end
