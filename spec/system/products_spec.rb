require 'rails_helper'

RSpec.describe "Products", type: :system do
  before do
    driven_by(:rack_test)
  end

  it 'products should be seen on home page' do
    product = FactoryBot.create(:product)
    product_2 = FactoryBot.create(:product)
    visit root_path
    expect(page).to have_text(product.name)
    expect(page).to have_text(product_2.name)
  end
end
