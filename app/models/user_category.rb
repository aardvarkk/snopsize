class UserCategory < ActiveRecord::Base
  # Associations
  belongs_to :user
  has_many :snops_to_user_categories, :class_name => "SnopToUserCategory"
  has_many :snops, :through => :snops_to_user_categories

  # Validations
  # A user can not be null, and it must always exist
  validates_presence_of :user_id, :user

  # can't have null or empty name
  validates :name, :presence => true, :length => { :minimum => 1 }

  # Children must be uniquely named for each user
  validates_uniqueness_of :name, :scope => :user_id

  attr_accessible :name, :user_id
end
