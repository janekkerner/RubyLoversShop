# frozen_string_literal: true

module ShoppingCartServices
  class AddProductToCart
    def call(cart:, product:, quantity: 1)
      cart_items = cart.cart_items
      cart_item = cart_items.find_by(product_id: product.id)
      if cart_item
        increment_cart_item(cart_item)
      else
        create_product_in_cart(cart, product, quantity)
      end
    end

    private

    def increment_cart_item(cart_item)
      cart_item.increment(:quantity)
      if cart_item.save
        PayloadObject.new(message: "Quantity of #{cart_item.product_name} has been incremented",
                          payload: { cart_item: cart_item })
      else
        PayloadObject.new(message: 'Sorry, product quantity cannot be increased',
                          payload: { cart_item: cart_item }, errors: cart_item.errors)
      end
    end

    def create_product_in_cart(cart, product, quantity)
      cart_product = cart.cart_items.build(product_id: product.id, quantity: quantity)
      if cart_product.save
        PayloadObject.new(message: "Product #{product.name} has been added to your shopping cart")
      else
        PayloadObject.new(errors: cart_product.errors.full_messages)
      end
    end
  end
end
