User.all.find_each do |user|
  user.create_shopping_cart if user.shopping_cart == nil
end
