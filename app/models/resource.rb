class Resource < ActiveRecord::Base
  # Association
  has_many :snops
  belongs_to :domain

  # Validation
  validates_presence_of :domain_id, :uri
  # Must belong to a domain that exists
  validates_presence_of :domain

  attr_accessible :domain_id, :uri
end
