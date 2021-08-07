# frozen_string_literal: true

class CartItem < ApplicationRecord
  belongs_to :product
  belongs_to :shopping_cart
<<<<<<< HEAD
=======

  delegate :name, :price, to: :product, prefix: 'product'
>>>>>>> master
end
