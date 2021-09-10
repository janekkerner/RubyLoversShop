# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Products', type: :system do
  let!(:product) { create(:product) }

  before do
    driven_by(:rack_test)
  end

  context 'when user visit home page' do
    before do
      visit root_path
    end

    it 'product tile has a name value' do
      within '.row#products' do
        expect(page).to have_text(product.name)
      end
    end

    it 'product tile has a price value' do
      within '.row#products' do
        expect(page).to have_text(product.price)
      end
    end

    it 'see all products' do
      within '.row#products' do
        expect(page).to have_css('.card-img-top', count: 1)
      end
    end

    it 'can go to product page by clicking the product name' do
      within '.row#products' do
        click_link product.name
      end
      expect(page).to have_selector("#product-#{product.id}-page")
    end

    it 'can go to product page by clicking the product photo' do
      within '.row#products' do
        find("#product-#{product.id}-photo").click
      end
      expect(page).to have_selector("#product-#{product.id}-page")
    end
  end

  context 'when user visit product page' do
    before do
      visit product_path(product)
    end

    it 'can see product name' do
      expect(page).to have_text(product.name)
    end

    it 'can see product price' do
      expect(page).to have_text(product.price)
    end

    it 'can see product description' do
      expect(page).to have_selector('#description')
    end

    it 'can see product photo' do
      expect(page).to have_selector('.card-img-top')
    end
  end
end
