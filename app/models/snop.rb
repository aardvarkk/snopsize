class Snop < ActiveRecord::Base
  belongs_to :user
	
  attr_accessible :point1, :point2, :point3, :source, :summary, :title, :user_id

  # make the entire text of the snop searchable
  searchable do 
  	text :title, :point1, :point2, :point3, :summary
  end

end
