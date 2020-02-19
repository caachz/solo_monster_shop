class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :street_address
      t.string :city
      t.string :state
      t.integer :zip
      t.integer :role, default: 0
      t.string :email
      t.string :password_digest

      t.timestamps
    end
  end
end
