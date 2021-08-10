class Admin::OrdersController < ApplicationController
  layout 'dashboard'

  def index
    @pagy, @records = pagy(Order.all.order('created_at DESC'))
    render :index, locals: { orders: @records, pagy: @pagy }
  end
end
