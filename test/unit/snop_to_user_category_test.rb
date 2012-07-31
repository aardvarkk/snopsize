require 'test_helper'

class SnopToUserCategoryTest < ActiveSupport::TestCase
  # Test mandatory fields (i.e. not null)
  test "mandatory fields" do
    # Can't create without user_category and snop
    snop_to_user_category = SnopToUserCategory.new
    assert !snop_to_user_category.save, "Saved snop to user category without user category id and snop id!"

    # Can't create without snop id
    snop_to_user_category = SnopToUserCategory.new(
      :user_category_id => user_categories(:one).id
      )
    assert !snop_to_user_category.save, "Saved snop to user category without snop_id!"

    # Can't create without user category id
    snop_to_user_category = SnopToUserCategory.new(
      :snop_id => snops(:one).id
      )
    assert !snop_to_user_category.save, "Saved snop to user category without user category id!"

    # Need at vary least: user category id, and snop id
    snop_to_user_category = SnopToUserCategory.new(
      :user_category_id => user_categories(:one).id,
      :snop_id => snops(:one).id
      )
    assert snop_to_user_category.save, "Unable to save snop to user category with mandatory fields!"
  end

  # A snop must exist if we are to point to it
  test "existing snop" do
    snop_to_user_category = SnopToUserCategory.new(
      :user_category_id => user_categories(:one).id, 
      :snop_id => snops(:one).id
      )
    assert snop_to_user_category.save, "Unable to save with valid snop!"

    invalid_snop_to_user_category = SnopToUserCategory.new(
      :user_category_id => user_categories(:one).id, 
      :snop_id => 425245
      )
    assert !invalid_snop_to_user_category.save, "Saved with invalid snop!"
  end

  # A category must exist if we are to point to it
  test "existing category" do
    snop_to_user_category = SnopToUserCategory.new(
      :user_category_id => user_categories(:one).id, 
      :snop_id => snops(:one).id
      )
    assert snop_to_user_category.save, "Unable to save with valid category!"

    invalid_snop_to_user_category = SnopToUserCategory.new(
      :user_category_id => 243, 
      :snop_id => snops(:one).id
      )
    assert !invalid_snop_to_user_category.save, "Saved with invalid category!"
  end

  # Each snop can belong to at most 1 category per user
  test "snop in one category for user" do
    # First lets add snop "one" to user cateogory "one"
    snop_to_user_category = SnopToUserCategory.new(
      :user_category_id => user_categories(:one).id,
      :snop_id => snops(:one).id
      )
    assert snop_to_user_category.save, "Unable to save valid entry!"

    # Now lets try to add snop "one" to user category "two",
    # belonging to the same user, this should fail
    snop_to_user_category = SnopToUserCategory.new(
      :user_category_id => user_categories(:two).id,
      :snop_id => snops(:one).id
      )
    assert !snop_to_user_category.save, "Saved a snop in more than 1 category for a user!"
  end
end
