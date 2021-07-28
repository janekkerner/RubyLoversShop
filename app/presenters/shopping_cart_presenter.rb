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
end
