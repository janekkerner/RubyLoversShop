module CheckoutServices
  class CreateOrder
    def call(user)
      cart_products = user.shopping_cart.products
      if cart_products.empty?
        OpenStruct.new({ success?: false, message: 'Your shopping cart is empty. Add some products to continue checkout'})
      else
        create_order(user, cart_products)
      end
    end

    private

    def create_order(user, products)
      order_products = products.ids
      order = Order.new(user_id: user.id, products: order_products)
      if order.save
        user.shopping_cart.products.destroy_all
        OpenStruct.new({ success?: true, message: "Your order with number #{order.id} was created", order: order })
      else
        OpenStruct.new({ success?: false, message: "We couldn't create your order. Try again later", errors: order.errors })
      end
    end
  end
end
