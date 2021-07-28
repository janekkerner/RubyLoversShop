FactoryBot.define do
  factory :order_item do
    association :product
    association :order
  end
end
