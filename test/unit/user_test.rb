require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "mandatory fields" do
    # Can't create without username/password/email
    user = User.new
    assert !user.save, "Saved user without username/email/password!"

    # Can't create without password
    user = User.new(
      :email => "test@email.com",
      :username => "testuser"
      )
    assert !user.save, "Saved user without password!"

    # Can't create without email
    user = User.new(
      :username => "testuser",
      :password => "testpass"
      )
    assert !user.save, "Saved user without email!"

    # Can't create without username
    user = User.new(
      :email => "test@email.com",
      :password => "testpass"
      )
    assert !user.save, "Saved user without username!"

    # Need at vary least: email, username, password
    user = User.new(
      :email => "test@email.com",
      :password => "testpassword",
      :username => "Joe"
      )
    assert user.save, "Unable to save user with mandatory fields!"
  end

  test "duplicate username" do
    # Can't create a duplicate username
    user = User.new(
      :email => "test@email.com",
      :username => "test", 
      :password => "apassword")
    assert user.save

    # Now try again
    user2 = User.new(
      :email => "test2@email.com",
      :username => "test", 
      :password => "apassword")
    assert !user2.save, "Saved user with duplicate username!"
  end

  test "duplicate email" do
    # Can't create a duplicate email
    user = User.new(
      :email => "test@email.com",
      :username => "test", 
      :password => "apassword")
    assert user.save

    # Now try again
    user2 = User.new(
      :email => "test@email.com",
      :username => "test1", 
      :password => "apassword")
    assert !user2.save, "Saved user with duplicate email!"
  end

end
