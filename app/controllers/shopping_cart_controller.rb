# frozen_string_literal: true

class ShoppingCartController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cart, only: %i[show add_product_to_cart]
  before_action :set_product, only: %i[add_product_to_cart]

  def show
    cart_items = @cart.cart_items
    render :show, locals: { cart_items: cart_items }
  end

  def add_product_to_cart
    result = ShoppingCartServices::AddProductToCart.new.call(current_user.shopping_cart, @product)
    if result.success?
      flash[:success] = result.message
    else
      flash[:notice] = result.error || result.message
    end
    redirect_to cart_path
  end

  def destroy_cart_items
    cart_items = current_user.shopping_cart.cart_items
    if cart_items.any?
      cart_items.destroy_all
      flash[:notice] = 'Your shopping cart has been cleared'
    else
      flash[:alert] = 'Your shopping cart is empty and cannot be cleared'
    end
    redirect_back fallback_location: root_path
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def set_cart
    @cart = current_user.shopping_cart || current_user.create_shopping_cart
  end
end
