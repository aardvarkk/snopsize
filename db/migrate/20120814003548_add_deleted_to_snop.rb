class AddDeletedToSnop < ActiveRecord::Migration
  def change
  	add_column :snops, :deleted, :boolean, :null => false, :default => 0
  end
end
