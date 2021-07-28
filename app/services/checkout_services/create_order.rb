# frozen_string_literal: true

module CheckoutServices
  class CreateOrder
    def call(user)
      cart_products = user.shopping_cart.products
      if cart_products.empty?
        OpenStruct.new({ success?: false,
                         message: 'Your shopping cart is empty. Add some products to continue checkout' })
      else
        create_order(user, cart_products)
      end
    end

    private

    def create_order(user, products)
      order = Order.new(user_id: user.id)
      move_products_to_order(order, products)
      if order.save
        user.shopping_cart.products.destroy_all
        OpenStruct.new({ success?: true, message: "Your order with number #{order.id} was created", payload: order })
      else
        OpenStruct.new({ success?: false, message: "We couldn't create your order. Try again later",
                         errors: order.errors })
      end
    end

    def move_products_to_order(order, products)
      products.each do |product|
        order.order_items.build(product_id: product.id)
      end
    end
  end
end
