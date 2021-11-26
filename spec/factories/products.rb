# frozen_string_literal: true

FactoryBot.define do
  factory :product do
    sequence(:name) { |n| "Product no. #{n}" }
    sequence(:price) { |n| n + 10 }
    association :category
    association :brand
  end
end
