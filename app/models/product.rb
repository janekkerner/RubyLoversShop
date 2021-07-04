# frozen_string_literal: true

class Product < ApplicationRecord
  has_one_attached :image

  validates :name, presence: true
  validates :price, presence: true

  belongs_to :category
  belongs_to :brand, optional: true

  scope :with_category, ->(category) { where category_id: category }
  scope :with_brand, ->(brand) { where brand_id: brand }
end
