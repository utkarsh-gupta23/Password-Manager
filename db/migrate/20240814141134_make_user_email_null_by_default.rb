class MakeUserEmailNullByDefault < ActiveRecord::Migration[7.1]
  def change
    change_column :users, :email, :string, null: true
    remove_index :users, :email if index_exists?(:users, :email)
  end
end
