module ShoppingCartServices
  class AddProductToCart
    def call(cart, product)
      if cart.cart_items.map(&:product_id).include?(product.id)
        OpenStruct.new({ success?: false, message: 'Product is already in your shopping cart' })
      else
        create_product_in_cart(cart, product)
      end
    end

    private

    def create_product_in_cart(cart, product)
      cart_product = cart.cart_items.build(product_id: product.id)
      if cart_product.save
        OpenStruct.new({ success?: true, message: 'Product added to your shopping cart'})
      else
        OpenStruct.new({ success?: false, error: cart_product.errors })
      end
    end
  end
end
