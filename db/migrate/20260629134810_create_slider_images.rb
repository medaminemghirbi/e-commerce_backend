class CreateSliderImages < ActiveRecord::Migration[8.0]
  def change
    create_table :slider_images do |t|
      t.string  :title,      default: ""
      t.string  :subtitle,   default: ""
      t.string  :image_url,  null: false
      t.string  :link_url,   default: ""
      t.string  :link_label, default: ""
      t.integer :sort_order, default: 0
      t.boolean :active,     default: true

      t.timestamps
    end
  end
end
