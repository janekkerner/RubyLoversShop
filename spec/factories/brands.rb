FactoryBot.define do
  factory :brand do
    sequence(:brand_name) { |n| "Brand #{n}" }
  end
end
