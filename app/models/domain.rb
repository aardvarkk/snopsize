class Domain < ActiveRecord::Base
	# Associations
	has_many :resources
	has_many :snops

	# Validations
	# must have a uri (can't be null)
	validates_presence_of :uri

  attr_accessible :uri
end
