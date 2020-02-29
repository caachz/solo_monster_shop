class CreateDiscountTable < ActiveRecord::Migration[5.1]
  def change
    create_table :discount_tables do |t|
      t.integer :quantity
      t.integer :discount
      t.references :merchant, foreign_key: true
      t.timestamps
    end
  end
end
