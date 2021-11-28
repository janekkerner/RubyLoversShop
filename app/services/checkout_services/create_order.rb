# frozen_string_literal: true

module CheckoutServices
  class CreateOrder
    def call(user:, cart_items_params: {})
      initialize_cart_items(user)
      recalculate_shopping_cart(shopping_cart: user.shopping_cart, cart_items_params: cart_items_params)
      if @cart_items.reload.empty?
        PayloadObject.new({ errors: 'Your shopping cart is empty. Add some products to continue checkout' })
      else
        create_order(user)
      end
    end

    private

    def initialize_cart_items(user)
      @cart_items = user.shopping_cart.cart_items
    end

    def recalculate_shopping_cart(shopping_cart:, cart_items_params:)
      ShoppingCartServices::RecalculateShoppingCart.new.call(
        shopping_cart: shopping_cart,
        cart_items_params: cart_items_params
      )
    end

    def create_order(user)
      @cart_items.reload
      initialize_order(user)
      move_products_from_cart_to_order
      add_total_price_to_order
      if @order.save
        user.shopping_cart.products.destroy_all
        PayloadObject.new({ message: "Your order with ID: #{@order.id} was created", payload: @order })
      else
        PayloadObject.new({ message: "We couldn't create your order. Try again later",
                            errors: @order.errors })
      end
    end

    def add_total_price_to_order
      result = CalculateTotalPrice.new.call(@order.order_items)
      @order.update!(total_price: result.payload)
    end

    def initialize_order(user)
      @order = Order.new(user_id: user.id)
    end

    def move_products_from_cart_to_order
      @cart_items.each do |cart_item|
        build_order_item_from_cart_item(cart_item)
      end
    end

    def build_order_item_from_cart_item(cart_item)
      @order.order_items.build(product_id: cart_item.product_id, quantity: cart_item.quantity)
    end
  end
end
