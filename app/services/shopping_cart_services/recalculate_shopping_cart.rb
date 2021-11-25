# frozen_string_literal: true

module ShoppingCartServices
  class RecalculateShoppingCart
    def call(shopping_cart:, cart_items_params: nil)
      messages = []
      errors = []
      cart_items = shopping_cart.cart_items

      cart_items.each do |cart_item|
        old_quantity = old_quantity(cart_item)
        new_quantity = cart_items_params[cart_item.id.to_s][:quantity]
        next if quantity_not_changed?(old_quantity, new_quantity)

        result = ShoppingCartServices::RecalculateItem.new.call(cart_item: cart_item, quantity: new_quantity)
        messages << result.message if result.message
        errors << result.errors if result.errors
      end

      response_message = messages.to_sentence if messages.any?
      if errors.any?
        PayloadObject.new(message: response_message, errors: errors, payload: { cart_items: cart_items })
      else
        PayloadObject.new(message: response_message, payload: { cart_items: cart_items })
      end
    end

    private

    def old_quantity(cart_item)
      cart_item.quantity.to_s
    end

    def quantity_not_changed?(old_quantity, new_quantity)
      old_quantity == new_quantity
    end
  end
end
