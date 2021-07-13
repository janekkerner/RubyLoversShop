Product.all.find_each do |product|
  product.create_shopping_cart if product.shopping_cart == nil
end
