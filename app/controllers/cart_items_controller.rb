class CartItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cart, only: %i[create]
  before_action :set_product, only: %i[create]

  def create
    quantity = params[:quantity]
    result = ShoppingCartServices::AddProductToCart.new.call(cart: @cart, product: @product, quantity: quantity)
    if result.success?
      flash[:success] = result.message
    else
      flash[:notice] = result.errors || result.message
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
