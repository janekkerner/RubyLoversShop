module Admin
  class PaymentsController < ApplicationController
    before_action :authenticate_admin_user!
    before_action :set_payment

    def update
      action = params[:event]
      @payment.send(action) #if @payment.send("may_#{action}?")
      order = @payment.order
      if @payment.save
        flash[:notice] = "Payment has been updated"
      else
        flash[:alert] = "Something went wrong"     
      end
      redirect_to admin_order_path(order)
    end

    private

    def set_payment
      @payment = Payment.find(params[:id])
    end
  end
end