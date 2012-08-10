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

    user = User.new(
      :email => "test@email.com",
      :password => "testpassword",
      :username => "Joe"
      )
    assert !user.save, "Able to save a username with a capital letter!"

    user = User.new(
      :email => "test@email.com",
      :password => "testpassword",
      :username => "joe"
      )
    assert user.save, "Unable to save a valid user."

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

    # Try again with different capitalization
    user2 = User.new(
      :email => "test2@email.com",
      :username => "Test", 
      :password => "apassword")
    assert !user2.save, "Saved user with capitalization-altered username!"

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

  test "invalid usernames" do

    user = User.new(
      :email => "test@email.com",
      :password => "testpassword",
      :username => "Joe "
      )
    assert !user.save, "Saved username with space in it"

    user = User.new(
      :email => "test@email.com",
      :password => "testpassword",
      :username => "Joe%"
      )
    assert !user.save, "Saved username with symbols in it"

    user = User.new(
      :email => "test@email.com",
      :password => "testpassword",
      :username => "joe_user"
      )
    assert user.save, "Couldn't save a username with an underscore"

    user = User.new(
      :email => "test2@email.com",
      :password => "testpassword",
      :username => "0joe_user0"
      )
    assert user.save, "Couldn't save a username with digits in it"

  end

end
