# frozen_string_literal: true

module Admin
  class OrderPresenter
    def initialize(order)
      @order = order
      @payment = order.payment
      @shipment = order.shipment
    end

    def payment_permitted_events
      @payment.aasm.events(permitted: true).map(&:name)
    end

    def shipment_permitted_events
      @shipment.aasm.events(permitted: true).map(&:name)      
    end
  end
end
