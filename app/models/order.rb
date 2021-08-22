# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items
  has_one :payment, dependent: :destroy
  has_one :shipment, dependent: :destroy

  enum state: {
    new: 0,
    failed: 1,
    completed: 2
  }, _prefix: :state

  before_create :build_payment
  before_create :build_shipment

  delegate :aasm_state, :id, to: :payment, prefix: 'payment'
  delegate :aasm_state, :id, to: :shipment, prefix: 'shipment'
end
