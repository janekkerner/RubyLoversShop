require 'rails_helper'

RSpec.describe "Products", type: :system do

  before do
    driven_by(:rack_test)
  end

  describe "when user visit home page" do

    it 'should see all products' do
      @product = FactoryBot.create(:product)
      @product_2 = FactoryBot.create(:product)
      visit root_path
      expect(page).to have_text(@product.name)
      expect(page).to have_text(@product_2.name)
      expect(page).to have_css('.card-img-top', count: 2 )
    end
  end
end
