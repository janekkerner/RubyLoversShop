# frozen_string_literal: true
class PagesController < ApplicationController
  def home
    @products = Product.all.order('created_at ASC')
  end
end
