require 'test_helper'

class DomainTest < ActiveSupport::TestCase
  test "mandatory fields" do
    # Can't create without uri
    domain = Domain.new
    assert !domain.save, "Saved domain without uri!"

    # Need at a minimum a uri
    domain = Domain.new(
      :uri => "a uri"
      )
    assert domain.save, "Can't save domain!"
  end

  # Shouldn't be allowed to add a domain with the same URI
  test "domain uniqueness" do
    domain = Domain.new(
      :uri => domains(:one).uri
      )
    assert !domain.save, "Saved a Domain with same URI!"
  end

  # Domains should not be case sensitive! That is 
  # www.globeandmail.com is the same as WWW.GLOBEANDMAIL.COM
  test "domain case insensitivity" do
    domain = Domain.new(
      :uri => "www.testdomain.com"
      )
    assert domain.save, "Unable to save valid domain!"

    # Now try to create the same one but with all uppercase
    domain = Domain.new(
      :uri => "WWW.TESTDOMAIN.COM"
      )
    assert !domain.save, "Saved uppercase version of existing domain!"

    # Now try some more crazy stuff with the domain... it still shouldn't pass
    domain = Domain.new(
      :uri => "www.TESTDOMAIN.coM"
      )
    assert !domain.save, "Saved crazy case sensitive domain!"
  end
end
