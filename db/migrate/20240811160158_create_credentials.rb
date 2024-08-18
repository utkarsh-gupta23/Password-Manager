class CreateCredentials < ActiveRecord::Migration[7.1]
  def change
    create_table :credentials do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.string :username
      t.string :password
      t.string :website

      t.timestamps
    end
  end
end
