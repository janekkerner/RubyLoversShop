# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CartItem, type: :model do
  subject(:item) { described_class.new(shopping_cart: shopping_cart, product: product) }

  let!(:shopping_cart) { create(:shopping_cart) }
  let!(:product) { create(:product) }

  it 'quantity should be greater than 0' do
    item.quantity = 5
    expect(item).to be_valid
  end

  it 'quantity cannot be empty' do
    item.quantity = nil
    expect(item).not_to be_valid
  end

  it 'quantity should not be string' do
    item.quantity = 'a'
    expect(item).not_to be_valid
  end
end
