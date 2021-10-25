# frozen_string_literal: true

module CheckoutServices
  class CreateOrder
    def call(user, cart_items_params)
      cart_items = user.shopping_cart.cart_items
      if cart_items.empty?
        OpenStruct.new({ success?: false,
                         message: 'Your shopping cart is empty. Add some products to continue checkout' })
      else
        cart_items.each do |cart_item|
          cart_item.quantity = cart_items_params[cart_item.id.to_s][:quantity]
        end
        create_order(user, cart_items)
      end
    end

    private

    def create_order(user, cart_items)
      order = Order.new(user_id: user.id)
      move_products_to_order(order, cart_items)
      result = CalculateTotalPrice.new.call(order.order_items)
      order.total_price = result.payload
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
        order.order_items.build(product_id: cart_item.product_id, quantity: cart_item.quantity)
      end
    end
  end
end
