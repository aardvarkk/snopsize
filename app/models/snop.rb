class Snop < ActiveRecord::Base

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

  # validate using the custom UriValidator
  before_validation :normalize_uri
  validates :uri, :uri => true

  # Fields can only be a max of 256 chars for the snop
  validates :title, :point1, :point2, :point3, :summary, :length => { :maximum => 256 }

  # We can't edit a snop, or any of its fields,
  # therefore all of the attributes are readonly.
  # We leave them as accessible as well so that we can
  # do a mass assign when we create.
  attr_accessible :user_id, :domain_id, :resource_id, :title, :point1, :point2, :point3, :summary, :uri, :is_ad, :popularity, :deleted
  attr_readonly :user_id, :domain_id, :resource_id, :title, :point1, :point2, :point3, :summary, :uri, :is_ad

  # set the domain and resource before saving based
  # on the URI
  before_save :set_domain_and_resource, :unless => "uri.nil?"

  # make the entire text of the snop searchable
  searchable do
    text :title, :point1, :point2, :point3, :summary
  end

  # Try to normalize the URI, so that we convert from capitals and stuff
  def normalize_uri
    
    # Don't do anything on blanks
    return if self.uri.blank?

    # Try to parse, and set to nil if it fails
    uri = Addressable::URI.heuristic_parse(self.uri) rescue nil

    # Seems like it's possible to get here with a non-blank URI
    return if uri.blank?

    # Normalize it!
    self.uri = uri.normalize.to_s

  end

  def set_domain_and_resource

    # if we have a blank uri, then we don't have domain or resource
    return if self.uri.blank?

    # THE REMAINING STUFF SHOULD NOT FAIL
    # If it does, we didn't do the validation properly!

    # reparse our uri and set the domain and resource
    # we should already have passed validation to get here...
    valid_uri = Addressable::URI.heuristic_parse(self.uri)
    
    # Set the domain as the concatenation of the scheme and the host
    self.domain = Domain.find_or_create_by_uri(valid_uri.scheme + '://' + valid_uri.host)

    # Set the resource as the path
    # But the path can be nil (http://example.com), so we should set the path
    # to a forward slash in that case
    self.resource = self.domain.resources.find_or_create_by_uri(valid_uri.path.blank? ? '/' : valid_uri.path)

  end

end
