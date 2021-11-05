# frozen_string_literal: true

module CheckoutServices
  class CreateOrder
    def call(user:, options: {})
      options = { cart_items: nil }.merge(options)
      cart_items = user.shopping_cart.cart_items
      cart_items.each do |cart_item|
        break if options[:cart_items].nil?

        next if options[:cart_items][cart_item.id.to_s].nil?

        ShoppingCartServices::RecalculateItem.new.call(
          cart_item: cart_item,
          quantity: options[:cart_items][cart_item.id.to_s][:quantity]
        )
      end
      if cart_items.reload.empty?
        PayloadObject.new({ errors: 'Your shopping cart is empty. Add some products to continue checkout' })
      else
        create_order(user, cart_items.reload)
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
        PayloadObject.new({ message: "Your order with ID: #{order.id} was created", payload: order })
      else
        PayloadObject.new({ message: "We couldn't create your order. Try again later",
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
