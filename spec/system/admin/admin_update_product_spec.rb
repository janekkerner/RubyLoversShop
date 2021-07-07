# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::Products#update', type: :system do
  let!(:product) { create(:product) }
  let!(:admin) { create(:admin_user) }

  before do
    driven_by(:rack_test)
  end

  describe 'when admin is visiting dashboard' do
    before do
      sign_in admin
      create(:category)
      create(:brand)
    end

    it 'can get page to update choosen product' do
      visit admin_path
      click_link 'Update', id: "update-product-#{product.id}"
      expect(page).to have_text("Edit product | ID: #{product.id}")
    end

    it 'can update product with valid data' do
      visit edit_admin_product_path(product)
      fill_in 'name', with: 'Updated name'
      fill_in 'Price:', with: '123.123'
      click_button 'Update product'
      expect(page).to have_text("Product with ID: #{product.id} has been updated")
    end

    it 'cannot update product without valid price data' do
      visit edit_admin_product_path(product)
      fill_in 'name', with: 'Updated product'
      fill_in 'Price:', with: 'ABC'
      click_button 'Update product'
      expect(page).to have_text('Price is not a number')
    end

    it 'cannot update product without valid name data' do
      visit edit_admin_product_path(product)
      fill_in 'name', with: ''
      fill_in 'Price:', with: '123'
      click_button 'Update product'
      expect(page).to have_text("Name can't be blank")
    end
  end
end
