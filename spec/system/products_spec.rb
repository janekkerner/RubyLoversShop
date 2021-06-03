require 'rails_helper'

RSpec.describe "Products", type: :system do
  
  let!(:product) { create(:product) }
  let!(:product2) { create(:product) }

  before do
    driven_by(:rack_test)
  end

  describe "when user visit home page" do

    it 'should see all products' do
      visit root_path
      within '.row#products' do
        expect(page).to have_text(product.name)
        expect(page).to have_text(product2.name)
        expect(page).to have_css('.card-img-top', count: 2 )
      end
    end
  end
end
