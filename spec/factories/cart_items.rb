# frozen_string_literal: true

FactoryBot.define do
  factory :cart_item do
    association :product
    association :shopping_cart
    quantity { 1 }
    trait :higher_quantity do
      quantity { 10 }
    end
  end
end
