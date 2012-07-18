class CreateSnops < ActiveRecord::Migration
  def change
    create_table :snops do |t|
      t.integer :user_id
      t.string :source
      t.string :title
      t.string :point1
      t.string :point2
      t.string :point3
      t.string :summary

      t.timestamps
    end
  end
end
