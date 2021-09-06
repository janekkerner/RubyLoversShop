# frozen_string_literal: true

class Order < ApplicationRecord
  include AASM

  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items
  has_one :payment, dependent: :destroy
  has_one :shipment, dependent: :destroy

  before_create :build_payment
  before_create :build_shipment

  delegate :aasm_state, :id, to: :payment, prefix: 'payment'
  delegate :aasm_state, :id, to: :shipment, prefix: 'shipment'

  enum state: {
    new: 0,
    failed: 1,
    completed: 2
  }, _prefix: :state

  aasm column: :state, enum: true do
    state :new, initial: true
    state :failed, :completed

    event :complete do
      transitions from: :new, to: :completed, guard: :payment_and_shipment_completed?
    end

    event :refuse do
      transitions from: :new, to: :failed
    end
  end

  def payment_and_shipment_completed?
    payment.completed? && shipment.shipped?
  end

  delegate :email, to: :user, prefix: 'user'
end
