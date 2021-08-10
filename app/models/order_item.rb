# frozen_string_literal: true

class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product
  
  delegate :name, :price, to: :product, prefix: 'product'
end
