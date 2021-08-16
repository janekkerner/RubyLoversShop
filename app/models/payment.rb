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
  
  enum status: {
    pending: 0,
    failed: 1,
    completed: 2
  }, _prefix: 'status'
end
