require 'addressable/uri'
require 'net/http'

class URIValidator < ActiveModel::Validator

  def get_or_redirect(uri)

    # get initial response
    r = Net::HTTP.get_response(uri)

    # grab the redirect if necessary
    case r
    when Net::HTTPRedirection
      uri = URI.parse(r['location'])
    end

    # return our value
    return uri
    
  end

  def validate(record)

    # testing a URI
    # uri = Addressable::URI.parse('geekologie.com/2012/07/for-open-mic-on-mos-eisley-custom-built.php?utm_source=feedburner&utm_medium=feed&utm_campaign=Feed%3A+geekologie%2FiShm+%28Geekologie+-+Gadgets%2C+Gizmos%2C+and+Awesome%29')
    # uri = Addressable::URI.parse('theglobeandmail.com/news/world/12-dead-after-masked-gunman-opens-fire-at-batman-premiere/article4429306')
    uri = Addressable::URI.parse('zdnet.com/new-mac-trojan-installs-silently-no-password-required-7000001519')

    # force http scheme (protocol)
    uri.scheme = 'http'

    # if the host is nil, use the path as the host
    if uri.host.nil?

      # take the path into the host to start
      host = uri.path

      # partition on slashes
      deslashed = host.partition('/');

      # remake based on the host + path
      uri.path = deslashed[1..2].join
      uri.host = deslashed[0]

    end

    # make a uri just out of the host to make sure we get the http and www stuff right
    # then try it out and redirect if necessary
    uri_host_only = uri.dup
    uri_host_only.path = nil
    uri_host_only = get_or_redirect(uri_host_only)

    # now copy that corrected host back into the original
    uri.host = uri_host_only.host
    uri = get_or_redirect(uri)

    p uri.host
    p uri.path

    # make sure we get a 200
    p Net::HTTP.get_response(uri)

  end

end
