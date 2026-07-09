class CreateCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :categories do |t|
      t.string :name_fr
      t.string :name_ar
      t.string :name_en
      t.text :description
      t.string :icon

      t.timestamps
    end
  end
end
