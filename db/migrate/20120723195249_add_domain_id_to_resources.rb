class AddDomainIdToResources < ActiveRecord::Migration
  def change
  	add_column :resources, :domain_id, :integer
  end
end
