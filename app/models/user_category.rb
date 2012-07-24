class UserCategory < ActiveRecord::Base
  has_many :snops
  has_many :children, :class_name => "UserCategory", :foreign_key => "parent_id"
  belongs_to :parent, :class_name => "UserCategory"

  attr_accessible :name, :parent_id, :user_id
end
