# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.first_or_create(email: 'user@example', password: 'password', password_confirmation: 'password')

5.times do |n|
  Category.where(name: "Category #{n + 1}").first_or_create
end

7.times do |n|
  Brand.where(brand_name: "Brand #{n + 1}").first_or_create
end

15.times do |n|
  Product.where(name: "Product #{n + 1}").first_or_create(price: ((n + 1) * 111), category_id: rand(1..5), brand_id: rand(1..7))
end
