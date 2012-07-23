class CreateResources < ActiveRecord::Migration
  def change
    create_table :resources do |t|
      t.string :uri

      t.timestamps
    end
  end
end
