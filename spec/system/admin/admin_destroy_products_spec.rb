# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::Products#destroy', type: :system do
  let!(:product) { create(:product) }
  let!(:admin) { create(:admin_user) }

  before do
    driven_by(:rack_test)
  end

  describe 'when admin is visiting dashboard' do
    it 'can remove choosen product' do
      sign_in admin
      visit admin_path
      click_link 'Delete', id: "destroy-product-#{product.id}"
      expect(page).to have_text("Product with ID: #{product.id} has been deleted")
    end
  end
end
