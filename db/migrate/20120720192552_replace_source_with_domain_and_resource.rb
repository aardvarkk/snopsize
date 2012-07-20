class ReplaceSourceWithDomainAndResource < ActiveRecord::Migration
  def up
  	rename_column :snops, :source, :domain
  	add_column :snops, :resource, :string
  end

  def down
  end
end
