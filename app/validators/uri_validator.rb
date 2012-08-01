class UriValidator < ActiveModel::EachValidator
  include UriHelper

  def validate_each(record, attribute, value)
    record.errors.add(attribute, "Invalid URL") unless get_response(Addressable::URI.parse(value)).class <= Net::HTTPSuccess
  end
end