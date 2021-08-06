# frozen_string_literal: true

module ProductHelper
  def product_image_exist?(product)
    if product.image.attached?
      product.image
    else
      'http://placehold.it/700x700'
    end
  end

  def calculate_total_price(cart_item)
    cart_item.product_price * cart_item.quantity
  end
end
