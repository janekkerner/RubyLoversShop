# frozen_string_literal: true

FactoryBot.define do
  factory :shopping_cart do
    association :user
  end
end
