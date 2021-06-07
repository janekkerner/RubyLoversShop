# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Filters', type: :system do
  let!(:category) { create(:category) }
  let!(:category2) { create(:category) }
  let!(:brand) { create(:brand) }
  let!(:brand2) { create(:brand) }
  let!(:product) { create(:product, category_id: category.id, brand_id: brand.id) }
  let!(:product2) { create(:product, category_id: category2.id, brand_id: brand2.id) }

  before do
    driven_by(:rack_test)
  end

  describe 'when user is selecting category' do
    it 'see only products from selected category' do
      visit root_path
      click_link category.name.to_s
      expect(page).to have_text(product.name)
    end

    it 'doesnt see products from other categories' do
      visit root_path
      click_link category.name.to_s
      expect(page).not_to have_text(product2.name)
    end
  end

  describe "when user is selecting brand" do
    it 'see only products from selected brand' do
      visit root_path
      click_link brand.brand_name.to_s
      expect(page).to have_text(product.name)
    end

    it 'doesnt see products from other brands' do
      visit root_path
      click_link brand.brand_name.to_s
      expect(page).not_to have_text(product2.name)
    end
  end

  describe "when user is selecting category and brand" do
    it "see only products that belongs to selected category and brand" do
      visit root_path
      click_link category.name.to_s
      click_link brand.brand_name.to_s
      expect(page).to have_text(product.name)
    end
    it "doesnt see products that belongs to other category or brand" do
      visit root_path
      click_link category.name.to_s
      click_link brand.brand_name.to_s
      expect(page).not_to have_text(product2.name)
    end
  end
end
