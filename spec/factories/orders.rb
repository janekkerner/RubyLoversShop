# frozen_string_literal: true

FactoryBot.define do
  factory :order do
    state { 'new' }
    total_price { 100 }
    association :user
  end
end
