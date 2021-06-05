# frozen_string_literal: true

class PagesController < ApplicationController
  def home
    @categories = Category.all
    render :home, layout: true, locals: { products: product_collection}
    p params
  end

  private

  def product_collection
    if (params[:category_id] != nil)
      Product.with_category(params[:category_id])
    else
      Product.all
    end
  end
end
