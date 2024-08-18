class AddEmailToUsers < ActiveRecord::Migration[7.1]
  def up
    add_column :users, :email, :string, null: false, default: ""
    add_index :users, :email, unique: true
  end

  def down
    remove_column :users, :email
  end
end
