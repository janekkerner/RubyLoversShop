class RemoveProductsFromOrder < ActiveRecord::Migration[6.1]
  def change
    remove_column :orders, :products, :integer, array: true
  end
end
