class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :name
      t.integer :price
      t.string :description
      t.string :photo_url
      t.integer :stock
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
