User.all.find_each do |user|
  user.create_shopping_cart if product.shopping_cart == nil
end
