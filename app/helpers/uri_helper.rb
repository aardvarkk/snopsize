require 'net/http'
require 'addressable/uri'
require 'public_suffix'

module UriHelper 
  OpenTimeout = 2
  ReadTimeout = 2

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

  def canonicalize(original_uri)
    # parse a URI from the attribute name
    uri = Addressable::URI.parse(original_uri)

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
    original_uri = uri.to_s
  end
end
