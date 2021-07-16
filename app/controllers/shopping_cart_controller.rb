# frozen_string_literal: true

class ShoppingCartController < ApplicationController
  before_action :authenticate_user!

  def show
    shopping_cart_products = current_user.shopping_cart.products
    render :show, locals: { products: shopping_cart_products }
  end

  def add_product_to_cart
    product = Product.find(params[:id])
    result = ShoppingCartServices::AddProductToCart.new.call(current_user.shopping_cart, product)
    if result.success?
      flash[:success] = result.message
    else
      flash[:notice] = result.error || result.message
    end
    redirect_to cart_path
  end
end
