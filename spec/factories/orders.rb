FactoryBot.define do
  factory :order do
    value { "9.99" }
    products { "MyString" }
    state { "" }
  end
end
