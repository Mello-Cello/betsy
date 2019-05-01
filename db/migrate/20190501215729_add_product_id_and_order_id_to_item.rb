class AddProductIdAndOrderIdToItem < ActiveRecord::Migration[5.2]
  def change
    add_reference :items, :product, foreign_key: true
    add_reference :items, :order, foreign_key: true
  end
end
