# frozen_string_literal: true

class Product < ApplicationRecord
  has_one_attached :image
  belongs_to :category
  belongs_to :brand, optional: true
  scope :with_category, ->(category) { Product.where(category_id: category) }
end
