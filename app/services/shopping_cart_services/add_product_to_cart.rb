# frozen_string_literal: true

module ShoppingCartServices
  class AddProductToCart
    def call(cart, product)
      cart_items = cart.cart_items
      cart_item = cart_items.find_by(product_id: product.id)
      if cart_items.exists?(product_id: product.id) && !cart_item.nil?
        increment_cart_item(cart_item)
      else
        create_product_in_cart(cart, product)
      end
    end

    private

    def increment_cart_item(cart_item)
      cart_item.increment(:quantity)
      if cart_item.save
        OpenStruct.new({ success?: true, message: "Quantity of #{cart_item.product_name} has been incremented",
                         payload: { cart_item: cart_item } })
      else
        OpenStruct.new({ success?: false, message: 'Sorry, product quantity cannot be increased',
                         payload: { cart_item: cart_item } })
      end
    end

    def create_product_in_cart(cart, product)
      cart_product = cart.cart_items.build(product_id: product.id)
      if cart_product.save
        OpenStruct.new({ success?: true, message: "Product #{product.name} has been added to your shopping cart" })
      else
        OpenStruct.new({ success?: false, error: cart_product.errors })
      end
    end
  end
end
