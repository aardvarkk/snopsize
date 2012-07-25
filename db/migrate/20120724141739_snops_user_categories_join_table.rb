class SnopsUserCategoriesJoinTable < ActiveRecord::Migration
  def change
    create_table :snops_user_categories, :id => false do |t|
      t.integer :snop_id
      t.integer :user_category_id
    end
  end
end
