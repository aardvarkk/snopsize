class FaveSnop < ActiveRecord::Base
  # Associations
  belongs_to :user
  belongs_to :snop

  # Validations
  # Make sure the foreign keys are non null
  validates_presence_of :user_id, :snop_id

  # Make sure foreign keys point to valid entries
  validates_presence_of :user, :snop

  # We can only favourite a snop once for each user
  validates_uniqueness_of :snop_id, :scope => :user_id
end