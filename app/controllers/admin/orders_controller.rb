# frozen_string_literal: true

module Admin
  class OrdersController < ApplicationController
    before_action :authenticate_admin_user!
    before_action :set_order, only: [:show, :update]

    layout 'dashboard'

    def index
      @pagy, @records = pagy(Order.order('created_at DESC'))
      render :index, locals: { orders: @records, pagy: @pagy }
    end

    def show
      payment = @order.payment || @order.create_payment
      shipment = @order.shipment || @order.create_shipment
      order_presenter = Admin::OrderPresenter.new(@order)
      render :show, locals: { order: @order, payment: payment, shipment: shipment, order_presenter: order_presenter }
    end

    def update
      event = params[:event]
      result = Admin::OrdersServices::StatusManager.new.call(@order, event)
      if result.success?
        flash[:notice] = result.message
      else
        flash[:alert] = result.message
      end
      redirect_to admin_order_path(@order)
    end

    private

    def set_order
      @order ||= Order.find(params[:id])
    end
  end
end
