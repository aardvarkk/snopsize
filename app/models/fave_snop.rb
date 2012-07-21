class FaveSnop < ActiveRecord::Base
  belongs_to :user
  belongs_to :snop
  # attr_accessible :title, :body
end
