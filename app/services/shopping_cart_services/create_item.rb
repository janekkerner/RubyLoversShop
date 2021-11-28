# frozen_string_literal: true

module ShoppingCartServices
  class CreateItem
    def call(cart:, product:, quantity: 1)
      @cart = cart
      @cart_items = @cart.cart_items
      cart_item = @cart_items.find_by(product_id: product.id)
      @quantity = define_quantity(quantity)
      if cart_item
        update_item_quantity(cart_item)
      else
        create_item(cart, product)
      end
    end

    private

    def define_quantity(quantity)
      quantity ||= 1
      quantity.to_i if quantity.to_i.positive?
    end

    def update_quantity(cart_item)
      cart_item.quantity += @quantity
      if cart_item.save
        PayloadObject.new(message: "Quantity of #{cart_item.product_name} has been incremented",
                          payload: { cart_item: cart_item })
      else
        PayloadObject.new(message: 'Sorry, product quantity cannot be increased',
                          payload: { cart_item: cart_item }, errors: cart_item.errors)
      end
    end

    def create_item(cart, product)
      cart_item = cart.cart_items.build(product_id: product.id, quantity: @quantity)
      if cart_item.save
        PayloadObject.new(message: "Product #{product.name} has been added to your shopping cart")
      else
        PayloadObject.new(errors: cart_item.errors.full_messages)
      end
    end
  end
end
