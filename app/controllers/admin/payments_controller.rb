# frozen_string_literal: true

module Admin
  class PaymentsController < ApplicationController
    before_action :authenticate_admin_user!
    before_action :set_payment

    def update
      event = params[:event]
      order = @payment.order
      result = Admin::OrdersServices::StatusManager.new.call(@payment, event)
      if result.success?
        flash[:notice] = result.message
      else
        flash[:alert] = result.message
      end
      redirect_to admin_order_path(order)
    end

    private

    def set_payment
      @payment = Payment.find(params[:id])
    end
  end
end
