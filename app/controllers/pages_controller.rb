# frozen_string_literal: true

class PagesController < ApplicationController
  def home
    @filters = {}
    @filters[:category_id] = params[:category_id] if params[:category_id].present?
    @filters[:brand_id] = params[:brand_id] if params[:brand_id].present?
    @categories = Category.all
    @brands = Brand.all
    render :home, locals: { products: product_collection }
  end

  private

  def product_collection
    if @filters[:category_id].nil? && @filters[:brand_id].nil?
      Product.order('created_at DESC')
    else
      products = Product.all
      products = products.with_category(@filters[:category_id]) if @filters[:category_id].present?
      products = products.with_brand(@filters[:brand_id]) if @filters[:brand_id].present?
      products.order('created_at DESC')
    end
  end
end
