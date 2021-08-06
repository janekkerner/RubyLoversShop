# frozen_string_literal: true

class CalculateTotalPrice
  def call(items)
    if items.any?
      total_price = items.inject(0) { |sum, item| sum + (item.product_price * item.quantity) }
      OpenStruct.new({ success?: true, payload: total_price })
    else
      total_price = 0
      OpenStruct.new({ success?: false, payload: total_price })
    end
  end
end
