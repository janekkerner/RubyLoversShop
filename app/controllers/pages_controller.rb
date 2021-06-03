# frozen_string_literal: true

class PagesController < ApplicationController
  def home
    @products = Product.order('created_at ASC')
  end
end
