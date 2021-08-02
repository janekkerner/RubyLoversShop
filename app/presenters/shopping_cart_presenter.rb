# frozen_string_literal: true

class ShoppingCartPresenter
  def initialize(cart_items)
    @cart_items = cart_items
  end

  def products_in_cart
    return 'Your shopping cart is empty.' if @cart_items.empty?

    products_number = @cart_items.uniq.count
    "You have #{products_number} #{'product'.pluralize(products_number)} in your shopping cart"
  end

  def show_total_price
    @cart_items.inject(0) { |sum, item| sum + (item.product.price * item.quantity) }
  end
end
