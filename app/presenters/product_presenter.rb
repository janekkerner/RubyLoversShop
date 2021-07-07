# frozen_string_literal: true

class ProductPresenter
  def initialize(product)
    @product = product
  end

  def show_brand
    @product.brand ? @product.brand.brand_name : ''
  end

  def image_attached
    @product.image.attached? ? @product.image : 'http://placehold.it/700x700'
  end
end
