class CreateFaveSnops < ActiveRecord::Migration
  def change
    create_table :fave_snops do |t|
      t.integer :user_id
      t.integer :snop_id
      t.timestamps
    end
  end
end
