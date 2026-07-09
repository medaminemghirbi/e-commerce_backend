class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :name_fr
      t.string :name_ar
      t.string :name_en
      t.text :description_fr
      t.text :description_ar
      t.text :description_en
      t.references :category, null: true, foreign_key: true
      t.decimal :purchase_price, precision: 10, scale: 2, default: 0
      t.decimal :selling_price,  precision: 10, scale: 2, default: 0
      t.integer :stock_quantity, default: 0
      t.text    :images, array: true, default: []
      t.date    :manufacture_date
      t.date    :expiration_date
      t.boolean :has_promotion,       default: false
      t.integer :promotion_discount,  default: 0
      t.string  :status, default: "active"

      t.timestamps
    end
  end
end
