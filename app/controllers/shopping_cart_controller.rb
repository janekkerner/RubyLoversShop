# frozen_string_literal: true

class ShoppingCartController < ApplicationController
  before_action :authenticate_user!

  def show
    shopping_cart_products = current_user.shopping_cart.products
    render :show, locals: { products: shopping_cart_products }
  end

  def add_product_to_cart
    if current_user.shopping_cart.cart_items.where(product_id: params[:id]).exists?
      flash[:error] = 'Product is already in your cart'
    else
      current_user.shopping_cart.cart_items.create(product_id: params[:id])
    end
    redirect_to cart_path
  end
end
