# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Checkouts', type: :system do
  let!(:user) { create(:user, shopping_cart: create(:shopping_cart)) }
  let!(:product) { create(:product) }
  let!(:product2) { create(:product) }

  before do
    driven_by(:rack_test)
  end

  describe 'when logged in user visit shopping cart' do
    before do
      sign_in user
      user.shopping_cart.cart_items.create(product_id: product.id)
      visit '/cart'
    end

    it 'can proceed to checkout' do
      click_link('Checkout', match: :first)
      expect(page).to have_text("Order ID: #{user.orders.last.id}")
    end

    it 'can see in order summary products that was in shopping cart before' do
      user.shopping_cart.cart_items.create(product_id: product2.id)
      click_link('Checkout')
      expect(page).to have_text(product.name.to_s)
      expect(page).to have_text(product2.name.to_s)
    end

    it 'cannot create order if shopping cart is empty' do
      user.shopping_cart.cart_items.destroy_all
      click_link('Checkout')
      expect(page).to have_text('Add some products to continue checkout')
    end

    it 'can clear products in shopping_cart' do
      visit '/cart'
      expect(page).to have_text('You have 1 product in your shopping cart')
      click_link('Clear cart')
      expect(page).to have_text('Your shopping cart is empty')
    end
  end
end
