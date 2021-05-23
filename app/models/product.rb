class Product < ApplicationRecord
  scope :by_categories, -> (category) { where('category = ?', category)}
  
  has_one_attached :image
end
