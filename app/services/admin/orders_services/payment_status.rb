# frozen_string_literal: true

module Admin
  module OrdersServices
    class PaymentStatus
      def call(object, event)
        object.send(event)
        object.save
      rescue AASM::InvalidTransition
        OpenStruct.new(success?: false, message: 'You are not allowed to do this operation')
      else
        OpenStruct.new(success?: true, message: 'Payment status has been updated')
      end
    end
  end
end
