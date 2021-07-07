# frozen_string_literal: true

module Admin
  class ProductsController < ApplicationController
    before_action :authenticate_admin_user!
    before_action :set_product, only: %i[edit update destroy]

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

    def edit
      render :edit, locals: { product: @product }
    end

    def update
      if @product.update(product_params)
        flash[:success] = "Product with ID: #{params[:id]} has been updated"
        redirect_to edit_admin_product_path(@product.id)
      else
        flash[:error] = @product.errors.full_messages.to_sentence
        render :edit, locals: { product: @product }
      end
    end

    def destroy
      if @product.destroy
        flash[:success] = "Product with ID: #{params[:id]} has been deleted"
      else
        flash[:error] = 'There was an error. Desired product has not been deleted'
      end
      redirect_to admin_path
    end

    private

    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params.require(:product).permit(:name, :price, :image, :category_id, :brand_id)
    end
  end
end
