class ReplaceOldPricesWithPrice < ActiveRecord::Migration[8.0]
  def up
    add_column :products, :price, :decimal, precision: 10, scale: 2, default: 0.0, null: false
    execute "UPDATE products SET price = selling_price"
    remove_column :products, :purchase_price
    remove_column :products, :selling_price
  end

  def down
    add_column :products, :selling_price, :decimal, precision: 10, scale: 2, default: 0.0
    add_column :products, :purchase_price, :decimal, precision: 10, scale: 2, default: 0.0
    execute "UPDATE products SET selling_price = price"
    remove_column :products, :price
  end
end
