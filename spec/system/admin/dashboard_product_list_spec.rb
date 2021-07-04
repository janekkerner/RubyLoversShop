# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Dashboard', type: :system do
  let!(:admin) { create(:admin_user) }
  let!(:product) { create(:product) }
  let!(:product1) { create(:product) }

  before do
    driven_by(:rack_test)
  end

  describe 'when admin is visiting dashboard' do
    it 'can see product list' do
      sign_in admin
      visit admin_dashboard_path
      expect(page).to have_text(product.name)
    end

    it 'can see all products' do
      sign_in admin
      visit admin_dashboard_path
      within 'tbody' do
        expect(page).to have_selector('img', count: 2)
      end
    end

    it 'can see product price' do
      sign_in admin
      visit admin_dashboard_path
      expect(page).to have_text(product.price)
    end
  end
end
