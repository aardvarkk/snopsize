class CreateDomains < ActiveRecord::Migration
  def change
    create_table :domains do |t|
      t.string :uri

      t.timestamps
    end
  end
end
