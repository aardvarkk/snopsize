class User < ActiveRecord::Base
  # Various associations
  has_many :snops
  has_many :fave_snops
  has_many :favourites, :through => :fave_snops, :source => :snop
  has_many :user_categories
  has_many :categorized_snops, :through => :user_categories, :source => :snops

  # Add username validation
  validates_presence_of :username
  validates_uniqueness_of :username
	
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body
end
