class CreateProductSubcategories < ActiveRecord::Migration[8.0]
  def change
    create_table :product_subcategories do |t|
      t.references :product, null: false, foreign_key: true
      t.references :subcategory, null: false, foreign_key: true

      t.timestamps
    end
  end
end
