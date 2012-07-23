class Resource < ActiveRecord::Base
	has_many :snops
  attr_accessible :uri
end
