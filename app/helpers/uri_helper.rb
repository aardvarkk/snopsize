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
end
