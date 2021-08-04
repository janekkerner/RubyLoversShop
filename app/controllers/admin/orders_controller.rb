class Admin::OrdersController < ApplicationController
  layout 'dashboard'
  
  def index
    orders = Order.all.order('created_at DESC')
    render :index, locals: { orders: orders }
  end
end
