# frozen_string_literal: true

class ShoppingCartController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cart

  def show
    shopping_cart_products = @cart.products
    render :show, locals: { products: shopping_cart_products }
  end

  private

  def set_cart
    @cart = current_user.shopping_cart || current_user.create_shopping_cart
  end
end
