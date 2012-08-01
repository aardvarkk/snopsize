class Domain < ActiveRecord::Base
	# Associations
	has_many :resources
	has_many :snops

	# Validations
	# must have a uri (can't be null), and must be unique
	validates :uri, :presence => true, :uniqueness => true

  attr_accessible :uri
end
