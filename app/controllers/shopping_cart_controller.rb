# frozen_string_literal: true

class ShoppingCartController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cart, only: %i[show update destroy]

  def show
    cart_items = @cart.cart_items
    render :show, locals: { cart_items: cart_items }
  end

  def update
    @cart.cart_items.each do |cart_item|
      cart_item.update(quantity: params[:cart_item][cart_item.id.to_s][:quantity])
      if cart_item.errors.any?
        flash[:alert] = "Something went wrong and we couldn't update your shopping cart"
        break
      else
        flash[:notice] = "Shopping cart has been updated"
      end
    end
    redirect_to cart_path
  end

  def destroy
    cart_items = @cart.cart_items
    if cart_items.any?
      cart_items.destroy_all
      flash[:notice] = 'Your shopping cart has been cleared'
    else
      flash[:alert] = 'Your shopping cart is empty and cannot be cleared'
    end
    redirect_back fallback_location: root_path
  end

  private

  def set_cart
    @cart = current_user.shopping_cart || current_user.create_shopping_cart
  end
end
