class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.references :user, null: true, foreign_key: true
      t.string  :user_email, null: false
      t.jsonb   :items,            default: []
      t.decimal :subtotal,         precision: 10, scale: 2, default: 0
      t.decimal :delivery_fee,     precision: 10, scale: 2, default: 8
      t.decimal :total,            precision: 10, scale: 2, default: 0
      t.string  :status,           default: "pending"
      t.string  :payment_method,   default: "cod"
      t.jsonb   :delivery_address, default: {}
      t.text    :notes

      t.timestamps
    end
  end
end
