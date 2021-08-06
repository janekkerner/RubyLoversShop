# frozen_string_literal: true

class ProductsController < ApplicationController
  layout 'products_list', only: [:index]

  def index
    @q = Product.ransack(params[:q])
    @products = @q.result.includes(:category, :brand).order('created_at DESC')
    render :index, locals: { products: @products }
  end

  def show
    @product = Product.find(params[:id])
    @presenter = ProductPresenter.new(@product)
    render :show, locals: { product: @product, presenter: @presenter }
  end
end
