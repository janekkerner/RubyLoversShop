# frozen_string_literal: true

class ProductsController < ApplicationController
  layout 'products_list'
  
  def index
    @q = Product.ransack(params[:q])
    @products = @q.result.includes(:category, :brand).order('created_at DESC')
    render :index, locals: { products: @products }
  end
end
