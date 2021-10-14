# frozen_string_literal: true

FactoryBot.define do
  factory :cart_item do
    association :product
    association :shopping_cart
    quantity { nil }
  end
end
