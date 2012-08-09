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
      return record.errors.add(attribute, 'Invalid URL')
    end

    # Not acceptible to have a blank host... that's bad
    # It would appear that a URI can be "valid" without having a host
    return record.errors.add(attribute, 'URL appears to be missing a host') if uri.host.blank?

    # Check that it's HTTP or HTTPS
    return record.errors.add(attribute, 'URL must be HTTP or HTTPS') if (!['http', 'https'].include? uri.scheme)

    # Check with public suffix list
    return record.errors.add(attribute, 'Invalid public suffix') if !PublicSuffix.valid?(uri.host)
    
  end
end