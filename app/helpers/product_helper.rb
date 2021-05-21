module ProductHelper
  def product_image_exist?(product)
    if product.image.attached?
      product.image
    else
      "http://placehold.it/700x700"
    end
  end
end
