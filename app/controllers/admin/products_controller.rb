# frozen_string_literal: true

module Admin
  class ProductsController < ApplicationController
    before_action :authenticate_admin_user!

    layout 'dashboard'

    def new
      @product = Product.new
    end

    def create
      @product = Product.new(product_params)
      if @product.save
        flash[:success] = 'Product has been created'
        redirect_to admin_path
      else
        flash[:error] = @product.errors.full_messages.to_sentence
        render :new
      end
    end

    def destroy
      @product = Product.find(params[:id])
      if @product.destroy
        flash[:success] = "Product with ID: #{params[:id]} has been deleted"
        redirect_to admin_path
      end
    end

    private

    def product_params
      params.require(:product).permit(:name, :price, :image, :category_id, :brand_id)
    end
  end
end
