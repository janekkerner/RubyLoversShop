class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.decimal :total_price
      t.integer :products, array: true
      t.integer :state, default: 0
      t.references :user

      t.timestamps
    end
  end
end
