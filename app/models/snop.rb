class Snop < ActiveRecord::Base
  belongs_to :user
	
  attr_accessible :point1, :point2, :point3, :source, :summary, :title, :user_id
end
