# frozen_string_literal: true

class ShoppingCartPresenter
  def initialize(cart_items)
    @cart_items = cart_items
  end

  def products_in_cart
    return 'Your shopping cart is empty.' if @cart_items.empty?

    products_count = @cart_items.uniq.count
    "You have #{products_count} #{'product'.pluralize(products_count)} in your shopping cart"
  end

  def show_total_price
    result = CalculateTotalPrice.new.call(@cart_items)
    result.payload
  end
end
