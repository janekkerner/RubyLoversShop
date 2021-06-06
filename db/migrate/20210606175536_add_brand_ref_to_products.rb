class AddBrandRefToProducts < ActiveRecord::Migration[6.1]
  def change
    add_reference :products, :brand, null: true, foreign_key: true
  end
end
