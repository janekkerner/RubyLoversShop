# frozen_string_literal: true

module ShoppingCartServices
  class RecalculateShoppingCart
    def call(shopping_cart:, cart_items_params: nil)
      cart_items = shopping_cart.cart_items
      messages = []
      errors = []
      cart_items.each do |cart_item|
        quantity = cart_items_params[cart_item.id.to_s][:quantity]
        result = ShoppingCartServices::RecalculateItem.new.call(cart_item: cart_item, quantity: quantity)
        messages << result.message if result.message
        errors << result.errors if result.errors.any?
      end
      if errors.any?
        PayloadObject.new(message: messages, errors: errors, payload: { cart_items: cart_items })
      else
        PayloadObject.new(message: messages, payload: { cart_items: cart_items })
      end
    end
  end
end
