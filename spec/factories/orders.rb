FactoryBot.define do
  factory :order do
    state { "" }
    association :user
  end
end
