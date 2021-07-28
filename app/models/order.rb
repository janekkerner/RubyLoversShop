# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items
  has_many :products, through: :order_items

  enum state: {
    new: 0,
    failed: 1,
    completed: 2
  }, _prefix: :state
end
