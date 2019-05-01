class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.string :status
      t.string :shopper_name
      t.string :shopper_email
      t.string :shopper_address
      t.string :cc_four
      t.string :cc_exp

      t.timestamps
    end
  end
end
