class ChangeTitleColumnInSnops < ActiveRecord::Migration
  def up
  	change_column_null :snops, :title, false
  end

  def down
  	change_column_null :snops, :title, true
  end
end
