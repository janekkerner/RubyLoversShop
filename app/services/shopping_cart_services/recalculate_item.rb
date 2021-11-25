# frozen_string_literal: true

module ShoppingCartServices
  class RecalculateItem
    def call(cart_item:, quantity: nil)
      quantity_normalized = define_quantity(quantity)
      return DestroyItem.new.call(cart_item: cart_item) if zero_quantity?(quantity_normalized)

      if cart_item.update(quantity: quantity_normalized)
        PayloadObject.new(
          message: "Quantity of #{cart_item.product_name} has been set to #{quantity_normalized}",
          payload: { cart_item: cart_item }
        )
      else
        cart_item.reload
        PayloadObject.new(
          message: "We couldn't update quantity of #{cart_item.product_name} product",
          errors: cart_item.errors.full_messages
        )
      end
    end

    private

    def zero_quantity?(quantity)
      quantity.to_i.zero?
    end

    def define_quantity(quantity)
      quantity.to_s if quantity.is_a?(Integer)
      quantity.presence || '1'
    end
  end
end
