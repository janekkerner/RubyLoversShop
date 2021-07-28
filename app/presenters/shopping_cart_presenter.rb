# frozen_string_literal: true

class ShoppingCartPresenter
  def initialize(products)
    @products = products
  end

  def products_in_cart
    return 'Your shopping cart is empty.' if @products.empty?

    products_number = @products.uniq.count
    "You have #{products_number} #{'product'.pluralize(products_number)} in your shopping cart"
  end

  def any_pending_orders
    link_to
  end
end
