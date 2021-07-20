# frozen_string_literal: true

class ShoppingCartController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cart

  def show
    shopping_cart_products = @cart.products
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

  private

  def set_cart
    @cart = current_user.shopping_cart || current_user.create_shopping_cart
  end
end
