module Admin
  class ShipmentsController < ApplicationController
    before_action :authenticate_admin_user!
    before_action :set_shipment

    def update
      event = params[:event]
      order = @shipment.order
      result = Admin::OrdersServices::StatusManager.new.call(@shipment, event)
      if result.success?
        flash[:notice] = result.message
      else
        flash[:alert] = result.message
      end
      redirect_to admin_order_path(order)
    end

    private

    def set_shipment
      @shipment = Shipment.find(params[:id])
    end
  end  
end

