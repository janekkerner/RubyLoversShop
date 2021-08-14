# frozen_string_literal: true

module Admin
  class OrdersController < ApplicationController
    before_action :authenticate_admin_user!

    layout 'dashboard'

    def index
      @pagy, @records = pagy(Order.all.order('created_at DESC'))
      render :index, locals: { orders: @records, pagy: @pagy }
    end

    def show
      order = Order.find(params[:id])
      render :show, locals: { order: order }
    end
  end
end
