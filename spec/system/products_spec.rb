# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Products', type: :system do
  let!(:product) { create(:product) }

  before do
    driven_by(:rack_test)
  end

  describe 'when user visit home page' do
    it 'product has a name value' do
      visit root_path
      within '.row#products' do
        expect(page).to have_text(product.name)
      end
    end

    it 'product has a price value' do
      visit root_path
      within '.row#products' do
        expect(page).to have_text(product.price)
      end
    end

    it 'see all products' do
      visit root_path
      within '.row#products' do
        expect(page).to have_css('.card-img-top', count: 1)
      end
    end
  end
end
