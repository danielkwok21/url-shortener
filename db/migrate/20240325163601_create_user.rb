class CreateUser < ActiveRecord::Migration[6.0]
  def up
    create_table :users do |t|
      t.string :email, unique: true, null: false
      t.string :name, unique: true, null: false
      t.string :password_digest

      t.timestamps
    end
  end
  
  def down
    drop_table :users
  end
end
