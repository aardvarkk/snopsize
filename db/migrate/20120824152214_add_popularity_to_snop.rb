class AddPopularityToSnop < ActiveRecord::Migration
  def change
    add_column :snops, :popularity, :decimal, :null => false, :default => 0
  end
end
