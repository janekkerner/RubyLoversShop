# frozen_string_literal: true

module CheckoutServices
  class CreateOrder
    def call(user)
      cart_items = user.shopping_cart.cart_items
      if cart_items.empty?
        OpenStruct.new({ success?: false,
                         message: 'Your shopping cart is empty. Add some products to continue checkout' })
      else
        create_order(user, cart_items)
      end
    end

    private

    def create_order(user, cart_items)
      order = Order.new(user_id: user.id)
      move_products_to_order(order, cart_items)
<<<<<<< HEAD
      order.total_price = order.order_items.inject(0) { |sum, item| sum + (item.product.price * item.quantity) }
=======
      result = CalculateTotalPrice.new.call(order.order_items)
      order.total_price = result.payload
>>>>>>> master
      if order.save
        user.shopping_cart.products.destroy_all
        OpenStruct.new({ success?: true, message: "Your order with ID: #{order.id} was created", payload: order })
      else
        OpenStruct.new({ success?: false, message: "We couldn't create your order. Try again later",
                         errors: order.errors })
      end
    end

    def move_products_to_order(order, cart_items)
      cart_items.each do |cart_item|
<<<<<<< HEAD
        order.order_items.build(product_id: cart_item.product.id, quantity: cart_item.quantity)
=======
        order.order_items.build(product_id: cart_item.product_id, quantity: cart_item.quantity)
>>>>>>> master
      end
    end
  end
end
