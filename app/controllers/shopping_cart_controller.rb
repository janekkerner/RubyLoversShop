# frozen_string_literal: true

class ShoppingCartController < ApplicationController
  before_action :authenticate_user!

  def show
    shopping_cart_products = current_user.shopping_cart.products
    render :show, locals: { products: shopping_cart_products }
  end
end
