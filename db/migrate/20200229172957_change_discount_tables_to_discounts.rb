class ChangeDiscountTablesToDiscounts < ActiveRecord::Migration[5.1]
  def change
    rename_table :discount_tables, :discounts
  end
end
