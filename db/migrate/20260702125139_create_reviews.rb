class CreateReviews < ActiveRecord::Migration[8.0]
  def change
    create_table :reviews do |t|
      t.references :user,  null: false, foreign_key: true
      t.references :order, null: false, foreign_key: true
      t.integer :rating,   null: false
      t.text    :comment
      t.boolean :published, default: false, null: false

      t.timestamps
    end
  end
end
