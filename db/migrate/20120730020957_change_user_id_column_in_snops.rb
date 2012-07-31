class ChangeUserIdColumnInSnops < ActiveRecord::Migration
  def up
  	change_column_null :snops, :user_id, false
  end

  def down
  	change_column_null :snops, :user_id, true
  end
end
