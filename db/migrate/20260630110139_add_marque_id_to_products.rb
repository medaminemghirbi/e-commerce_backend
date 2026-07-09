class AddMarqueIdToProducts < ActiveRecord::Migration[8.0]
  def change
    add_reference :products, :marque, foreign_key: true, null: true
  end
end
