# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Category.create(name: "Category 1")
Category.create(name: "Category 2")

Product.create(name: "Product 1", price: 999, category_id: 1)
Product.create(name: "Product 2", price: 888, category_id: 2)
Product.create(name: "Product 3", price: 777, category_id: 1)
Product.create(name: "Product 4", price: 666, category_id: 2)
