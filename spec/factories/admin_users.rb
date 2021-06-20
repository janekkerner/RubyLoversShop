FactoryBot.define do
  factory :admin_user do
    sequence(:email) { |n| "admin#{n}@admin.com" }
    password { 'admin123' }
  end
end
