class CreateUserCategories < ActiveRecord::Migration
  def change
    create_table :user_categories do |t|
      t.string :name
      t.integer :user_id
      t.integer :parent_id

      t.timestamps
    end
  end
end
