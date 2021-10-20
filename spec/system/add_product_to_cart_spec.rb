# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ShoppingCart#add_product_to_cart', type: :system do
  let!(:user) { create(:user, shopping_cart: create(:shopping_cart)) }
  let!(:product) { create(:product) }
  let!(:product2) { create(:product) }

  before do
    driven_by(:rack_test)
  end

  describe 'when guest is visiting home page' do
    it 'needs to sign in first, to add product to cart' do
      visit '/'
      within '#products' do
        click_link('Add to cart', match: :first)
      end
      expect(page).to have_text('You need to sign in or sign up before continuing.')
    end
  end

  describe 'when guest is visiting product page' do
    it 'needs to sign in first, to add product to cart' do
      visit "/products/#{product.id}"
      click_button('Add to cart', match: :first)
      expect(page).to have_text('You need to sign in or sign up before continuing.')
    end
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
  end

  describe 'when logged in user is visiting product page' do
    before do
      sign_in user
    end

    it 'can add product to his shopping cart' do
      visit "/products/#{product.id}"
      click_button('Add to cart')
      expect(page).to have_text('You have 1 product in your shopping cart')
      expect(page).to have_text("Product #{product.name} has been added to your shopping cart")
    end

    it 'can add product that is already in cart and increment its quantity' do
      visit "/products/#{product.id}"
      click_button('Add to cart')
      visit "/products/#{product.id}"
      click_button('Add to cart')
      expect(page).to have_text("Quantity of #{product.name} has been incremented")
    end

    it 'can add multiple products to shopping cart' do
      visit "/products/#{product.id}"
      click_button('Add to cart')
      visit "/products/#{product2.id}"
      click_button('Add to cart')
      expect(page).to have_text('You have 2 products in your shopping cart')
    end

    it 'can add product from product page with specified value' do
      visit "/products/#{product.id}"
      fill_in 'quantity', with: 5
      click_button('Add to cart')
      expect(page).to have_text("Product #{product.name} has been added to your shopping cart")
      expect(user.shopping_cart.cart_items.find_by(product_id: product.id).quantity).to be_equal(5)
    end
  end
end
