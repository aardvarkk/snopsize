class Snop < ActiveRecord::Base
  belongs_to :user
  belongs_to :domain
  belongs_to :resource
	
  attr_accessible :user_id, :domain_id, :resource_id, :title, :point1, :point2, :point3, :summary 

  # make the entire text of the snop searchable
  searchable do 
  	text :title, :point1, :point2, :point3, :summary
  end

end
