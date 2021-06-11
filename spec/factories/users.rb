# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "exampleemail#{n}@example.com" }
    password { 'P@ssword123' }
  end
end
