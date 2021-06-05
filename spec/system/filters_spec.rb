# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Filters', type: :system do
  let!(:category) { create(:category) }
  let!(:product) { create(:product, category_id: category.id) }
  let!(:product2) { create(:product) }

  before do
    driven_by(:rack_test)
  end

  describe 'when user is selecting category' do
    it 'see only products from selected category' do
      visit root_path
      click_link category.name.to_s
      expect(page).to have_text(product.name)
    end

    it ' see products from other categories' do
      visit root_path
      click_link category.name.to_s
      expect(page).not_to have_text(product2.name)
    end
  end
end
