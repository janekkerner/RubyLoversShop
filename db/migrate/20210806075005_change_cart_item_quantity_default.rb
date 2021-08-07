class ChangeCartItemQuantityDefault < ActiveRecord::Migration[6.1]
  def change
    change_column_default :cart_items, :quantity, from: 0, to: 1
  end
end
