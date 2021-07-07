# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::Products#create', type: :system do
  let!(:admin) { create(:admin_user) }
  let!(:product) { create(:product) }
  let!(:category) { create(:category) }
  let!(:brand) { create(:brand) }

  before do
    driven_by(:rack_test)
  end

  describe 'when admin is visiting dashboard' do
    it 'can visit create product page from dashboard' do
      sign_in admin
      visit admin_path
      within 'nav' do
        click_link 'Products'
        click_link 'New product'
      end
      expect(page).to have_text('Create product')
    end
  end

  describe 'when admin is visting product create page' do
    before do
      sign_in admin
      visit new_admin_product_path
    end

    it 'can create a product with all data' do
      fill_in 'name', with: product.name
      fill_in 'Price:', with: product.price
      attach_file 'image', 'app/assets/images/product_placeholder.jpg'
      select category.name, from: 'Category:'
      select brand.brand_name, from: 'Brand:'
      click_button 'Create product'
      expect(page).to have_text('Product has been created')
    end

    it 'cannot create a product without name' do
      fill_in 'name', with: ''
      fill_in 'Price:', with: product.price
      attach_file 'image', 'app/assets/images/product_placeholder.jpg'
      select category.name, from: 'Category:'
      select brand.brand_name, from: 'Brand:'
      click_button 'Create product'
      expect(page).to have_text('Name can\'t be blank')
    end

    it 'cannot create a product without price' do
      fill_in 'name', with: product.name
      fill_in 'Price:', with: ''
      attach_file 'image', 'app/assets/images/product_placeholder.jpg'
      select category.name, from: 'Category:'
      select brand.brand_name, from: 'Brand:'
      click_button 'Create product'
      expect(page).to have_text('Price can\'t be blank')
    end
  end
end
