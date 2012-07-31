class ChangeUriColumnInResources < ActiveRecord::Migration
  def up
  	change_column_null :resources, :uri, false
  end

  def down
  	change_column_null :resources, :uri, true
  end
end
