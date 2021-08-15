FactoryBot.define do
  factory :payment do
    status { 'pending' }
    order { nil }
  end
end
