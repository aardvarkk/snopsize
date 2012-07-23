class UseDomainAndResources < ActiveRecord::Migration
  def up
  	remove_column :snops, [:domain, :resource]
  	add_column :snops, :domain_id, :integer
  	add_column :snops, :resource_id, :integer
  end

  def down
  end
end
