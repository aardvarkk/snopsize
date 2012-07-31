class ChangeColumnsInUserCategories < ActiveRecord::Migration
  def up
    change_column_null :user_categories, :user_id, false
    change_column_null :user_categories, :name, false
  end

  def down
    change_column_null :user_categories, :user_id, true
    change_column_null :user_categories, :name, true
  end
end
