# frozen_string_literal: true

class ProductsController < ApplicationController
  def index
    @q = Product.ransack(params[:q])
    @products = @q.result.includes(:category, :brand).order('created_at DESC')
    render :index, locals: { products: @products }
  end

  private

  def product_params
    params.require(:product).permit(:name, :price, :image, :category_id, :brand_id)
  end
end
