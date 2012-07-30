class AddUriToSnop < ActiveRecord::Migration
  def change
  	add_column :snops, :uri, :string
  end
end
