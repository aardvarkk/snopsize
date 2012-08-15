class AddIsAdToSnop < ActiveRecord::Migration
  def change
    add_column :snops, :is_ad, :boolean, :null => false, :default => 0
  end
end
