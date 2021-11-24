# frozen_string_literal: true

module ShoppingCartServices
  class DestroyItem
    def call(cart_item:)
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
    end
  end
end
