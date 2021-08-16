# frozen_string_literal: true

class Payment < ApplicationRecord
  include AASM

  aasm do
    state :pending, intial: true
    state :failed, :completed

    event :confirm do
      transitions from: :pending, to: :completed
    end

    event :reject do
      transitions from: :pending, to: :failed
    end
  end

  belongs_to :order
end
