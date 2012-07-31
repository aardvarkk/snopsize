class SnopToUserCategory < ActiveRecord::Base
  # Naming issue requires this, we want snop and user category pluralized
  self.table_name = "snops_to_user_categories"

  # Associations
  belongs_to :user_category
  belongs_to :snop 

  # Validations
  # The id's cannot be NULL
  validates_presence_of :snop_id, :user_category_id

  # The id's must point to existing rows
  validates_presence_of :snop, :user_category

  # Make sure that a snop is in only 1 category per user
  validate :snop_in_one_category_per_user

  attr_accessible :snop_id, :user_category_id

  # Make sure that a user can only assign 1 category to a user
  def snop_in_one_category_per_user
    unless (user_category.nil? || snop.nil?)
      if (user_category.user.categorized_snops.find_by_id(snop.id))
        errors.add(:snop, "snop is already categorized for this user.")
      end
    end
  end
end
