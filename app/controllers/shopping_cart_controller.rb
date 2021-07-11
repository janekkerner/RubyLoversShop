class ShoppingCartController < ApplicationController
  def show
    products = current_user.shopping_cart.nil? ? current_user.build_shopping_cart : current_user.shopping_cart 
    render :show, locals: {products: products}
  end
end
