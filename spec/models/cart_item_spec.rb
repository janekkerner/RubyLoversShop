require 'rails_helper'

RSpec.describe CartItem, type: :model do
  let!(:shopping_cart) { create(:shopping_cart) }
  let!(:product) { create(:product) }
  let!(:cart_item) { build(:cart_item, shopping_cart: shopping_cart, product: product) } 

  it 'quantity should be greater than 0' do
    cart_item.quantity = 5
    cart_item.save
    expect(cart_item).to be_valid
  end

  it 'quantity should not be empty' do
    cart_item.quantity = nil
    cart_item.save
    expect(cart_item).not_to be_valid
  end

  it 'quantity should not be string' do
    cart_item.quantity = 'a'
    cart_item.save
    expect(cart_item).not_to be_valid
  end
end
