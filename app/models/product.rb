# frozen_string_literal: true

class Product < ApplicationRecord
  has_one_attached :image

  validates :name, presence: true
  validates :price, presence: true, numericality: true

  belongs_to :category
  belongs_to :brand, optional: true
  has_many :cart_items
  has_many :shopping_carts, through: :cart_items

  scope :with_category, ->(category) { where category_id: category }
  scope :with_brand, ->(brand) { where brand_id: brand }
end
