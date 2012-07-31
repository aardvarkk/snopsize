class UserCategory < ActiveRecord::Base
  # Associations
  belongs_to :user
  has_many :snops_to_user_categories, :class_name => "SnopToUserCategory"
  has_many :snops, :through => :snops_to_user_categories
  has_many :children, :class_name => "UserCategory", :foreign_key => "parent_id", :dependent => :destroy
  belongs_to :parent, :class_name => "UserCategory" 

  # Validations
  # A user can not be null, and it must always exist
  validates_presence_of :user_id, :user

  # can't have null or empty name
  validates :name, :presence => true, :length => { :minimum => 1 }

  # If the parent id is not null, the parent has to exist
  validates_presence_of :parent, :unless => "parent_id.nil?"

  # Children must be uniquely named for each parent category (including root)
  validates_uniqueness_of :name, :scope => :parent_id

  attr_accessible :name, :parent_id, :user_id
end
