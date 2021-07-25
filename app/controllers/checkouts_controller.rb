class CheckoutsController < ApplicationController
  before_action :authenticate_user!

  def show
    order = current_user.orders.select { |o| o.state_new? }.last
    render :show, locals: { order: order }
  end

  def create
    result = CheckoutServices::CreateOrder.new.call(current_user)
    if result.success?
      flash[:success] = result.message
      render :show, locals: { order: result.payload }
    else
      flash[:error] = result.errors || result.message
      redirect_to root_path
    end
  end
end
