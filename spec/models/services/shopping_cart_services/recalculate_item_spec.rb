# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable RSpec/MultipleExpectations

RSpec.describe ShoppingCartServices::RecalculateItem, type: :model do
  describe '#call' do
    let!(:shopping_cart) { create(:shopping_cart) }
    let!(:product) { create(:product) }
    let!(:cart_item) { create(:cart_item, shopping_cart: shopping_cart, product: product) }
    let!(:quantity) { '4' }

    it 'change quantity of cart item to specified value' do
      described_class.new.call(cart_item: cart_item, quantity: quantity)
      expect(cart_item.quantity).to eq(4)
    end

    it 'do not change quantity if value is nagative number' do
      described_class.new.call(cart_item: cart_item, quantity: '-5')
      expect(cart_item.quantity).not_to eq(-5)
      expect(cart_item.quantity).to eq(1)
    end

    it 'set quantity to 1 if quantity is not provided' do
      described_class.new.call(cart_item: cart_item, quantity: '')
      expect(cart_item.quantity).not_to eq('')
      expect(cart_item.quantity).to eq(1)
    end
  end
end

# rubocop:enable RSpec/MultipleExpectations
