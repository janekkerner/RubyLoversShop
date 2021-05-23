class ProductsController < ApplicationController

  def index
    if params[:category]
      @products = Product.by_categories(params[:category])
    else
      @products = Product.all
      render 'pages/home'
    end
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.build(product_params)
    @product.save
  end

  private

  def product_params
    params.require(:product).permit(:name, :price, :image)
  end
end
