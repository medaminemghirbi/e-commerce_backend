class CreateCoupons < ActiveRecord::Migration[8.0]
  def change
    create_table :coupons do |t|
      t.string  :code,              null: false
      t.string  :discount_type,     null: false  # 'percentage' or 'fixed'
      t.decimal :discount_value,    precision: 10, scale: 2, null: false
      t.decimal :min_order_amount,  precision: 10, scale: 2, default: 0.0
      t.integer :max_uses                          # nil = unlimited
      t.integer :used_count,        default: 0, null: false
      t.boolean :active,            default: true, null: false
      t.datetime :expires_at                       # nil = never expires

      t.timestamps
    end
    add_index :coupons, :code, unique: true
  end
end
