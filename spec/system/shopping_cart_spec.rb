# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ShoppingCart#update', type: :system do
  let!(:user) { create(:user, shopping_cart: create(:shopping_cart)) }
  let!(:shopping_cart) { user.shopping_cart }

  before do
    driven_by(:rack_test)
  end

  context 'when guest is visiting shopping cart' do
    it 'needs to sign in first, to see shopping cart' do
      visit '/cart'
      expect(page).to have_text('You need to sign in or sign up before continuing.')
    end
  end

  context 'when logged in user is visiting shopping cart' do
    let!(:cart_item) { create(:cart_item, shopping_cart: shopping_cart, product: create(:product)) }
    let!(:cart_item2) { create(:cart_item, shopping_cart: shopping_cart, product: create(:product)) }
    let!(:cart_item3) { create(:cart_item, :higher_quantity, shopping_cart: shopping_cart, product: create(:product)) }

    before do
      sign_in user
      visit '/cart'
    end

    it 'can update product quantity with provided value' do
      fill_in "_cart_items_#{cart_item.id}_quantity", with: 20
      click_button 'Recalculate'
      expect(page).to have_text("Quantity of #{cart_item.product_name} has been set to 20")
    end

    it 'can update multiple products quantity with provided value' do
      fill_in "_cart_items_#{cart_item.id}_quantity", with: 20
      fill_in "_cart_items_#{cart_item2.id}_quantity", with: 10
      click_button 'Recalculate'
      expect(page).to have_text("Quantity of #{cart_item.product_name} has been set to 20")
      expect(page).to have_text("Quantity of #{cart_item2.product_name} has been set to 10")
    end

    it 'can remove product from shopping cart when providing zero value' do
      fill_in "_cart_items_#{cart_item.id}_quantity", with: 0
      click_button 'Recalculate'
      expect(page).to have_text("#{cart_item.product_name} has been removed from your shopping cart")
    end

    it 'can remove product from shopping cart when providing zero value and change quantity of different product' do
      fill_in "_cart_items_#{cart_item.id}_quantity", with: 0
      fill_in "_cart_items_#{cart_item2.id}_quantity", with: 10
      click_button 'Recalculate'
      expect(page).to have_text("#{cart_item.product_name} has been removed from your shopping cart")
      expect(page).to have_text("Quantity of #{cart_item2.product_name} has been set to 10")
    end

    it 'will set quantity to 1 if no value was provided' do
      fill_in "_cart_items_#{cart_item3.id}_quantity", with: ''
      click_button 'Recalculate'
      expect(page).to have_text("Quantity of #{cart_item3.product_name} has been set to 1")
    end
  end
end
