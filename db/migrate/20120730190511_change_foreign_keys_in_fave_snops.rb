class ChangeForeignKeysInFaveSnops < ActiveRecord::Migration
  def up
  	change_column_null :fave_snops, :user_id, false
  	change_column_null :fave_snops, :snop_id, false
  end

  def down
  	change_column_null :fave_snops, :user_id, true
  	change_column_null :fave_snops, :snop_id, true
  end
end
