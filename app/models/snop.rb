require 'net/http'
require 'addressable/uri'
require 'public_suffix'

class Snop < ActiveRecord::Base

  OpenTimeout = 2
  ReadTimeout = 2

  # include HttpUtils

  belongs_to :user
  belongs_to :domain
  belongs_to :resource
  has_and_belongs_to_many :user_categories

  # validate using the custom URIValidator
  before_validation :canonicalize
  validate :valid_url

  # set the domain and resource before saving based
  # on the URI
  before_save :set_domain_and_resource

  attr_accessible :user_id, :uri, :domain_id, :resource_id, :title, :point1, :point2, :point3, :summary

  # make the entire text of the snop searchable
  searchable do
    text :title, :point1, :point2, :point3, :summary
  end

  def get_redirect(response)

    # grab the redirect given a response
    case response
    when Net::HTTPRedirection
      return URI.parse(response['location'])
    else
      return nil
    end

  end

  def get_response(uri)

    # make sure we have a host and a path
    return nil unless uri

    begin

      return Net::HTTP.start(uri.host) do |http|
        http.open_timeout = OpenTimeout
        http.read_timeout = ReadTimeout
        http.head(uri.path)
      end

    rescue
      return nil
    end

  end

  def canonicalize

    # parse a URI from the attribute name
    uri = Addressable::URI.parse(self.uri)

    # force to http
    uri.scheme = 'http'

    # if the host is nil, use the path as the host
    if uri.host.nil?

      # take the path into the host to start
      # and partition on slashes
      deslashed = uri.path.partition('/');

      # remake based on the host + path
      uri.path = deslashed[1..2].join
      uri.host = deslashed[0]

    end

    # check with public suffix if this is even valid
    # if not, save ourselves some work!
    return unless PublicSuffix.valid?(uri.host)

    # make a uri just out of the host to make sure we get the http and www stuff right
    # then try it out and redirect if necessary
    uri_host_only = uri.dup
    uri_host_only.path = '/'
    r = get_response(uri_host_only)
    # take a single redirect if necessary and get the new response
    if r.class < Net::HTTPRedirection
      uri_host_only = get_redirect(r)
    end

    # now copy that corrected host back into the original
    uri.host = uri_host_only.host
    r = get_response(uri)
    if r.class < Net::HTTPRedirection
      uri = get_redirect(r)
    end

    # valid, overwrite our uri
    self.uri = uri.to_s

  end

  # for validation
  def valid_url
    errors.add(:uri, "Invalid URL") unless get_response(Addressable::URI.parse(self.uri)).class <= Net::HTTPSuccess
  end

  def set_domain_and_resource
    # reparse our uri and set the domain and resource
    # we should already have passed validation to get here...
    valid_uri = URI.parse(self.uri)
    self.domain = Domain.find_or_create_by_uri(valid_uri.scheme + '://' + valid_uri.host)
    self.resource = self.domain.resources.find_or_create_by_uri(valid_uri.path)
  end

end
