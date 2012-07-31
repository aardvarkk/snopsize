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
end
