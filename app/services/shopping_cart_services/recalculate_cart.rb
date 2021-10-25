module ShoppingCartServices
  class RecalculateCart
    def call(cart_item:, quantity: 1)
      cart_item = CartItem.find(cart_item)
      quantity = 1 if quantity.empty?
      if quantity.to_i.zero?
        if cart_item.destroy
          PayloadObject.new(message: 'Product has been removed from your shopping cart', payload: { cart_item: cart_item })
        else
          PayloadObject.new(errors: cart_item.errors.full_messages, payload: { cart_item: cart_item })
        end
      else
        cart_item.update(quantity: quantity)
        if cart_item.save
          PayloadObject.new(message: "Quantity has been set to #{quantity}", payload: { cart_item: cart_item })
        else
          PayloadObject.new(message: "Something went wrong. We couldn't update quantity of selected product", errors: cart_item.errors.full_messages)
        end
      end
    end
  end
end
