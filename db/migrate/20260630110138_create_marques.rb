class CreateMarques < ActiveRecord::Migration[8.0]
  def change
    create_table :marques do |t|
      t.string :name
      t.text :description
      t.string :image

      t.timestamps
    end
  end
end
