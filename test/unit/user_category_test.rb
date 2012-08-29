require 'test_helper'

class UserCategoryTest < ActiveSupport::TestCase
  test "mandatory fields" do
    # Can't create without name/user_id
    category = UserCategory.new
    assert !category.save, "Saved category without user or name!"

    # Can't create without name
    category = UserCategory.new(
      :user_id => users(:one).id
      )
    assert !category.save, "Saved category without name!"

    # Can't create without user
    category = UserCategory.new(
      :name => "category!"
      )
    assert !category.save, "Saved category without user!"

    # Need at a minimum both user and name!
    category = UserCategory.new(
      :user_id => users(:one).id,
      :name => "category!"
      )
    assert category.save, "Can't save category!"
  end

  test "name length" do
    # Make sure name length > 0
    category = UserCategory.new(
      :user_id => users(:one).id,
      :name => ""
      )
    assert !category.save, "Saved name with no characters!"

    # Try with just 1 char, should be ok
    category = UserCategory.new(
      :user_id => users(:one).id,
      :name => "A"
      )
    assert category.save, "Can't save with 1 character as name!"
  end

  test "valid user" do
    # Make sure user exists
    category = UserCategory.new(:user_id => users(:one).id, :name => "CategoryA")
    assert category.save, "Unable to save with valid user!"

    # Try with invalid user that doesn't exist
    invalid_category = UserCategory.new(:user_id => 243, :name => "CategoryB")
    assert !invalid_category.save, "Saved with invalid user!"
  end

  test "unique naming" do
    category = user_categories(:one)

    # Try to add a category with the same name
    new_cat = UserCategory.new(
      :user_id => users(:one).id,
      :name => category.name
      )
    assert !new_cat.save, "Saved category with same name!"
  end

  test "unique naming between users" do
    category = user_categories(:one)

    # Try to add a user category with the same name, but for a
    # different user (should succeed)
    new_cat = UserCategory.new(
      :user_id => users(:two).id,
      :name => category.name
      )
    assert new_cat.save, "Can't save category with same name for different user!"
  end
end
