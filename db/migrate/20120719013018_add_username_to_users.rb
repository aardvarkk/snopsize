class AddUsernameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :username, :string
    
    # add username index
    add_index :users, :username, :unique => true
  end
end
