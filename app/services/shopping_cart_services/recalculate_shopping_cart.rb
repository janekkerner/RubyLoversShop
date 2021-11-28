# frozen_string_literal: true

module ShoppingCartServices
  class RecalculateShoppingCart
    def call(shopping_cart:, cart_items_params: nil)
      @messages = []
      @errors = []
      @cart_items_params = cart_items_params

      initialize_cart_items(shopping_cart)
      check_item_for_quantity_change
      create_response_sentence
      if @errors.any?
        PayloadObject.new(message: @response_message, errors: @errors, payload: { cart_items: @cart_items })
      else
        PayloadObject.new(message: @response_message, payload: { cart_items: @cart_items })
      end
    end

    private

    def check_item_for_quantity_change
      @cart_items.each do |cart_item|
        define_old_and_new_quantity(cart_item)
        next if quantity_unchanged?

        result = ShoppingCartServices::RecalculateItem.new.call(cart_item: cart_item, quantity: @new_quantity)
        add_message_to_array(array: @messages, result: result, method: :message)
        add_message_to_array(array: @errors, result: result, method: :errors)
      end
    end

    def add_message_to_array(array:, result:, method:)
      array << result.send(method)
    end

    def define_old_and_new_quantity(cart_item)
      initialize_old_quantity(cart_item)
      initialize_new_quantity(params: @cart_items_params, cart_item: cart_item)
    end

    def create_response_sentence
      @response_message = @messages.to_sentence if @messages.any?
    end

    def initialize_cart_items(shopping_cart)
      @cart_items = shopping_cart.cart_items
    end

    def initialize_new_quantity(params:, cart_item:)
      @new_quantity = params.dig(cart_item.id.to_s, :quantity)
    end

    def initialize_old_quantity(cart_item)
      @old_quantity = cart_item.quantity.to_s
    end

    def quantity_unchanged?
      @old_quantity == @new_quantity
    end
  end
end
