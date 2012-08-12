class Domain < ActiveRecord::Base
	# Associations
	has_many :resources
	has_many :snops

  # Callbacks
  before_validation :downcase_uri

	# Validations
	# must have a uri (can't be null), and must be unique
	validates :uri, :presence => true, :uniqueness => true

  attr_accessible :uri

  # We'll only deal with lowercase Domain URIs since 
  # Domains are not case sensitive.
  def downcase_uri 
    if self.uri
      self.uri = uri.downcase
    end
  end
end
