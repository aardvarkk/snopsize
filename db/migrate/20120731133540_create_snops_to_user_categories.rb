class CreateSnopsToUserCategories < ActiveRecord::Migration
  def change
    create_table :snops_to_user_categories do |t|
      t.integer :snop_id, :null => false
      t.integer :user_category_id, :null => false

      t.timestamps
    end

    drop_table :snops_user_categories
  end
end
