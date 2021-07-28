class CheckoutsController < ApplicationController
  before_action :authenticate_user!

  def show
    order = current_user.orders.select { |o| o.state_new? }.last
    @products = Product.where(id: order.products)
    render :show, locals: { order: order, products: @products }
  end

  def create
    result = CheckoutServices::CreateOrder.new.call(current_user)
    if result.success?
      flash[:success] = result.message
      redirect_to checkout_path, locals: { order: result.order, products: result.products }
    else
      flash[:error] = result.errors || result.message
      redirect_back fallback_location: root_path
    end
  end
end
