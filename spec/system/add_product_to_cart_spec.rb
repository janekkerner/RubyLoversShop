# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ShoppingCart#add_product_to_cart', type: :system do
  let!(:user) { create(:user, shopping_cart: create(:shopping_cart)) }
  let!(:product) { create(:product) }
  let!(:product2) { create(:product) }

  before do
    driven_by(:rack_test)
  end

  describe 'when logged in user is visiting home page' do
    before do
      sign_in user
    end

    it 'can add product to his shopping cart with product tile button' do
      visit '/'
      within '#products' do
        click_link('Add to cart', match: :first)
      end
      expect(page).to have_text('You have 1 product in your shopping cart')
    end

    it 'can add product to his shopping cart from specific product page' do
      visit "/products/#{product.id}"
      click_link('Add to cart')
      expect(page).to have_text('You have 1 product in your shopping cart')
      expect(page).to have_text("Product #{product.name} has been added to your shopping cart")
    end

    it 'cannot add product that is already in cart' do
      visit "/products/#{product.id}"
      click_link('Add to cart')
      visit "/products/#{product.id}"
      click_link('Add to cart')
      expect(page).to have_text('Product is already in your shopping cart')
    end

    it 'can add multiple products to shopping cart' do
      visit "/products/#{product.id}"
      click_link('Add to cart')
      visit "/products/#{product2.id}"
      click_link('Add to cart')
      expect(page).to have_text('You have 2 products in your shopping cart')
    end
  end
end
