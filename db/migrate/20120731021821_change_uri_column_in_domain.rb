class ChangeUriColumnInDomain < ActiveRecord::Migration
  def up
  	change_column_null :domains, :uri, false
  end

  def down
  	change_column_null :domains, :uri, true
  end
end
