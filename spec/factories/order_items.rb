# frozen_string_literal: true

FactoryBot.define do
  factory :order_item do
    association :product
    association :order
  end
end
