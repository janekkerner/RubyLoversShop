# frozen_string_literal: true

class CartItem < ApplicationRecord
  belongs_to :product
  belongs_to :shopping_cart

  validates :quantity, presence: true
  validates :quantity, numericality: { only_integer: true, greater_than: 0 }

  delegate :name, :price, to: :product, prefix: 'product'
end
