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

  test "domain uniqueness" do
    # Shouldn't be allowed to add a domain with the same URI
    domain = Domain.new(
      :uri => domains(:one).uri
      )
    assert !domain.save, "Saved a Domain with same URI!"
  end
end
