class CreateShoppingCartToAllUsers < ActiveRecord::Migration[6.1]
  def change
    reversible do |dir|
      dir.up do
        User.all.find_each do |u|
          u.create_shopping_cart if u.shopping_cart.nil?
        end
      end
      dir.down do
        User.all.find_each do |u|
          u.shopping_cart.destroy
        end
      end
    end
  end
end
