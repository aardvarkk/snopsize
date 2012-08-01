class Snop < ActiveRecord::Base
  include UriHelper

  # include HttpUtils

  # Associations
  belongs_to :user
  belongs_to :domain
  belongs_to :resource
  has_many :fave_snops # So we can do a :through
  has_many :users_that_faved, :through => :fave_snops, :source => :user
  has_many :snops_to_user_categories, :class_name => "SnopToUserCategory"
  has_many :user_categories, :through => :snops_to_user_categories

  # Validations
  # Make sure these values exist!
  validates_presence_of :user_id, :title
  # Make sure that the user_id foreign key is valid (i.e. The user object is itself present)
  validates_presence_of :user
	
  # We can't edit a snop, or any of its fields,
  # therefore all of the attributes are readonly.
  # We leave them as accessible as well so that we can
  # do a mass assign when we create.
  attr_accessible :user_id, :domain_id, :resource_id, :title, :point1, :point2, :point3, :summary, :uri
  attr_readonly :user_id, :domain_id, :resource_id, :title, :point1, :point2, :point3, :summary, :uri

  # validate using the custom URIValidator
  before_validation :canonicalize_url, :unless => "uri.nil?"
  validates :uri, :uri => true, :unless => "uri.nil?"

  # set the domain and resource before saving based
  # on the URI
  before_save :set_domain_and_resource, :unless => "uri.nil?"

  # make the entire text of the snop searchable
  searchable do
    text :title, :point1, :point2, :point3, :summary
  end

  def canonicalize_url
    canonicalize(self.uri)
  end

  def set_domain_and_resource
    # reparse our uri and set the domain and resource
    # we should already have passed validation to get here...
    valid_uri = URI.parse(self.uri)
    self.domain = Domain.find_or_create_by_uri(valid_uri.scheme + '://' + valid_uri.host)
    self.resource = self.domain.resources.find_or_create_by_uri(valid_uri.path)
  end

end
