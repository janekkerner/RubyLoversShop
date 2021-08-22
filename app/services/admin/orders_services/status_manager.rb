# frozen_string_literal: true

module Admin
  module OrdersServices
    class StatusManager
      def call(object, event)
        object.send(event)
        object.save
      rescue AASM::InvalidTransition
        OpenStruct.new(success?: false, message: 'You are not allowed to do this operation')
      else
        OpenStruct.new(success?: true,
                       message: "#{object.class.name.capitalize} status has been updated to #{object.aasm_state}")
      end
    end
  end
end
