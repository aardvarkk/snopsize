class UserCategory < ActiveRecord::Base
	belongs_to :user
	has_and_belongs_to_many :snops

  # attr_accessible :title, :body
end
