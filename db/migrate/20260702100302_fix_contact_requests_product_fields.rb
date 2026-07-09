class FixContactRequestsProductFields < ActiveRecord::Migration[8.0]
  def change
    change_column_null :contact_requests, :product_id, true
    add_column :contact_requests, :product_requested, :string unless column_exists?(:contact_requests, :product_requested)
  end
end
