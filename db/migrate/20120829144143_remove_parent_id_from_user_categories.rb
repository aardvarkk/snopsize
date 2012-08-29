class RemoveParentIdFromUserCategories < ActiveRecord::Migration
  def up
    remove_column :user_categories, :parent_id
  end

  def down
    add_column :user_categories, :parent_id, :integer
  end
end
