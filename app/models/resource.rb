class Resource < ActiveRecord::Base
	has_many :snops
  attr_accessible :domain_id, :uri
end
