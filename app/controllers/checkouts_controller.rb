# frozen_string_literal: true

class CheckoutsController < ApplicationController
  before_action :authenticate_user!

  def show
    if current_user.orders.any?
      order = current_user.orders.select(&:state_new?).last
      order_items = order.order_items
      render :show, locals: { order: order, order_items: order_items }
    else
      redirect_to cart_path
    end
  end

  def create
    result = CheckoutServices::CreateOrder.new.call(current_user)
    if result.success?
      flash[:success] = result.message
      redirect_to checkout_path, locals: { order: result.payload, products: result.payload.order_items }
    else
      flash[:error] = result.errors || result.message
      redirect_back fallback_location: root_path
    end
  end
end
