require 'addressable/uri'
require 'public_suffix'

class UriValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)

    # If it's blank, it's fine -- we don't need a URI
    return if value.blank?

    # Try to parse it as a URI in a forgiving manner
    begin
      uri = Addressable::URI.heuristic_parse(value);
    rescue
      record.errors.add(attribute, 'Invalid URL')
    end

    # Check that it's HTTP
    if uri.scheme != 'http'
      record.errors.add(attribute, 'URL must be HTTP')      
    end

    # Check with public suffix list
    if !PublicSuffix.valid?(uri.host)
      record.errors.add(attribute, 'Invalid public suffix')
    end
    
  end
end