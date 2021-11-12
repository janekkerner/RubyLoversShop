# frozen_string_literal: true

module ShoppingCartServices
  class RecalculateItem
    def call(cart_item:, quantity: nil)
      old_quantity = cart_item.quantity
      quantity = define_quantity(quantity)
      if quantity.to_i.zero?
        if cart_item.destroy
          PayloadObject.new(
            message: "Product #{cart_item.product_name} has been removed from your shopping cart",
            payload: { cart_item: cart_item }
          )
        else
          PayloadObject.new(
            message: "Something went wrong and we couldn't delete #{cart_item.product_name} from your shopping cart",
            errors: cart_item.errors.full_messages,
            payload: { cart_item: cart_item }
          )
        end
      elsif cart_item.update(quantity: quantity)
        message = "Quantity of #{cart_item.product_name} has been set to #{quantity}" if old_quantity != quantity.to_i
        PayloadObject.new(
          message: message,
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

    def define_quantity(quantity)
      quantity.to_s if quantity.is_a?(Integer)
      quantity.presence || 1
    end
  end
end
