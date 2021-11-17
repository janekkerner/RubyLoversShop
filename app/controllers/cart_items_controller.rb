# frozen_string_literal: true

class CartItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cart, only: %i[create]
  before_action :set_product, only: %i[create]

  def create
    quantity = params[:quantity]
    result = ShoppingCartServices::AddProductToCart.new.call(cart: @cart, product: @product, quantity: quantity)
    if result.success?
      flash[:success] = result.message
      redirect_to cart_path
    else
      flash[:notice] = result.errors || result.message
      redirect_back fallback_location: @product
    end
  end

  def delete
    cart_item = CartItem.find(params[:cart_item_id])
    if cart_item.destroy
      flash[:success] = "Product #{cart_item.product_name} has been removed from your shopping cart"
    else
      flash[:error] = "Something went wrong and we couldn't remove selected product"
    end
    redirect_to cart_path
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def set_cart
    @cart = current_user.shopping_cart || current_user.create_shopping_cart
  end
end
