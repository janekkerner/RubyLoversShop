# frozen_string_literal: true

module Admin
  class OrdersController < ApplicationController
    before_action :authenticate_admin_user!

    layout 'dashboard'

    def index
      @pagy, @records = pagy(Order.order('created_at DESC'))
      render :index, locals: { orders: @records, pagy: @pagy }
    end

    def show
      order = Order.find(params[:id])
      payment = order.payment || order.create_payment
      shipment = order.shipment || order.create_shipment
      order_presenter = Admin::OrderPresenter.new(order)
      render :show, locals: { order: order, payment: payment, shipment: shipment, order_presenter: order_presenter }
    end
  end
end
