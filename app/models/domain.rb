class Domain < ActiveRecord::Base
	has_many :resources
	has_many :snops
  attr_accessible :uri
end
