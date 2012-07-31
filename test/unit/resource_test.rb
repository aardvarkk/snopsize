require 'test_helper'

class ResourceTest < ActiveSupport::TestCase
  test "mandatory fields" do
    # Can't create without domain/uri
    resource = Resource.new
    assert !resource.save, "Saved resource without domain or uri!"

    # Can't create without domain
    resource = Resource.new(
      :uri => "test uri"
      )
    assert !resource.save, "Saved resource without domain!"

    # Can't create without uri
    resource = Resource.new(
      :domain_id => domains(:one).id
      )
    assert !resource.save, "Saved resource without uri!"

    # Need at a minimum both domain and uri
    resource = Resource.new(
      :uri => "a uri",
      :domain_id => domains(:one).id
      )
    assert resource.save, "Can't save resource!"
  end

  test "domain entry exists" do
    resource = Resource.new(
      :uri => "a uri",
      :domain_id => domains(:one).id
      )
    assert resource.save, "Can't save a valid resource!"

    # Now try with invalid domain
    invalid_resource = Resource.new(
      :uri => "another uri",
      :domain_id => 425
      )
    assert !invalid_resource.save, "Saved with invalid domain!"
  end
end
