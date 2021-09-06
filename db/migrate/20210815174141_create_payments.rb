class CreatePayments < ActiveRecord::Migration[6.1]
  def change
    create_table :payments do |t|
      t.integer :status, default: 0
      t.references :order, null: false, foreign_key: true

      t.timestamps
    end
  end
end
