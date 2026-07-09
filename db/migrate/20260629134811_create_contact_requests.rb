class CreateContactRequests < ActiveRecord::Migration[8.0]
  def change
    create_table :contact_requests do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone
      t.text :message
      t.references :product, null: false, foreign_key: true
      t.string :status

      t.timestamps
    end
  end
end
