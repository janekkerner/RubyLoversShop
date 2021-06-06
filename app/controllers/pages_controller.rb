# frozen_string_literal: true

class PagesController < ApplicationController
  def home
    @categories = Category.all
    render :home, layout: true, locals: { products: product_collection }
  end

  private

  def product_collection
    if params[:category_id].nil?
      Product.order('created_at DESC')
    else
      Product.with_category(params[:category_id])
    end
  end
end
