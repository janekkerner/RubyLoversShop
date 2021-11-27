# frozen_string_literal: true

module CheckoutServices
  class CreateOrder
    def call(user:, cart_items_params: {})
      cart_items = get_cart_items(user)
      prepare_cart_items(shopping_cart: user.shopping_cart, cart_items_params: cart_items_params)
      if cart_items.reload.empty?
        PayloadObject.new({ errors: 'Your shopping cart is empty. Add some products to continue checkout' })
      else
        create_order(user, cart_items.reload)
      end
    end

    private

    def get_cart_items(user)
      user.shopping_cart.cart_items
    end

    def prepare_cart_items(shopping_cart:, cart_items_params: {})
      ShoppingCartServices::RecalculateShoppingCart.new.call(shopping_cart: shopping_cart, cart_items_params: cart_items_params)
      # 
      # cart_items.each do |cart_item|
        # break if params[:cart_items].nil?
# 
        # next if params[:cart_items][cart_item.id.to_s].nil?
# 
        # new_quantity = params[:cart_items][cart_item.id.to_s][:quantity]
        # ShoppingCartServices::RecalculateItem.new.call(
          # cart_item: cart_item,
          # quantity: new_quantity
        # )
      # end
    end

    def create_order(user, cart_items)
      order = Order.new(user_id: user.id)
      move_products_from_cart_to_order(order, cart_items)
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

    def move_products_from_cart_to_order(order, cart_items)
      cart_items.each do |cart_item|
        build_order_item_from_cart_item(order, cart_item)
      end
    end

    def build_order_item_from_cart_item(order, cart_item)
      order.order_items.build(product_id: cart_item.product_id, quantity: cart_item.quantity)
    end
  end
end
