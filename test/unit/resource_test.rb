require 'test_helper'

class ResourceTest < ActiveSupport::TestCase
  # For the resource, uri and domain id cannot be null
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

  # The domain must exist (point to valid row)
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

  # A resource URI must be unique per domain
  test "uniqueness for domain" do
    # Add a Resource to the domain, should be ok
    resource = Resource.new(
      :uri => "a uri",
      :domain_id => domains(:one).id
      )
    assert resource.save, "Can't save a valid resource!"

    # Now try to add it again, shouldn't work
    resource = Resource.new(
      :uri => "a uri",
      :domain_id => domains(:one).id
      )
    assert !resource.save, "Added a URI with duplicate resource!!"

    # But we should be able to add the same uri name to a different domain
    resource = Resource.new(
      :uri => "a uri",
      :domain_id => domains(:two).id
      )
    assert resource.save, "Wasn't able to add same URI to different domain!"
  end

end
