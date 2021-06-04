# frozen_string_literal: true

FactoryBot.define do
  factory :product do
    sequence(:name) { |n| "Product no. #{n}" }
    price { '9.99' }
  end
end
