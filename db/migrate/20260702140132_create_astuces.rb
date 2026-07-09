class CreateAstuces < ActiveRecord::Migration[8.0]
  def change
    create_table :astuces do |t|
      t.string  :title,       null: false
      t.text    :description
      t.text    :images,      array: true, default: []
      t.string  :category,    default: 'Général'
      t.references :product,  foreign_key: true, null: true
      t.boolean :active,      default: true, null: false
      t.integer :sort_order,  default: 0

      t.timestamps
    end
  end
end
