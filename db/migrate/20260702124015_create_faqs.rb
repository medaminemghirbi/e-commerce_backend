class CreateFaqs < ActiveRecord::Migration[8.0]
  def change
    create_table :faqs do |t|
      t.string  :question,   null: false
      t.text    :answer,     null: false
      t.string  :category,   default: 'Général'
      t.integer :sort_order, default: 0
      t.boolean :active,     default: true, null: false

      t.timestamps
    end
  end
end
