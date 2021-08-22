# frozen_string_literal: true

class Shipment < ApplicationRecord
  include AASM

  aasm do
    state :pending, initial: true
    state :ready, :shipped, :failed, :canceled

    event :prepare do
      transitions from: :pending, to: :ready
    end

    event :cancel do
      transitions from: :pending, to: :canceled
    end

    event :ship do
      transitions from: :ready, to: :shipped, guard: :payment_completed?
    end

    event :fail do
      transitions from: :ready, to: :failed
    end
  end

  def payment_completed?
    order.payment_aasm_state == 'completed'
  end

  belongs_to :order
end
