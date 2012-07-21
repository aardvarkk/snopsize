class Snop < ActiveRecord::Base
  belongs_to :user
  has_many   :fave_snops
	
  attr_accessible :user_id, :domain, :resource, :title, :point1, :point2, :point3, :summary 

  # make the entire text of the snop searchable
  searchable do 
  	text :title, :point1, :point2, :point3, :summary
  end

end
