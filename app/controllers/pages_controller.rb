# frozen_string_literal: true

class PagesController < ApplicationController
  layout 'products_list'

  def home
    @q = Product.ransack(params[:q])
    @products = @q.result.includes(:category).includes(:brand).order('created_at DESC')
    render :home, locals: { products: @products }
  end
end
