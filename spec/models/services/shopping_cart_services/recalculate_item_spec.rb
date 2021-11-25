# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ShoppingCartServices::RecalculateItem, type: :model do
  describe '#call' do
    subject(:call) { described_class.new.call(cart_item: cart_item, quantity: quantity) }

    let!(:shopping_cart) { create(:shopping_cart) }
    let!(:product) { create(:product) }
    let!(:cart_item) { create(:cart_item, shopping_cart: shopping_cart, product: product) }
    let(:quantity) { '4' }

    context 'when quantity is positive number value' do
      it 'change quantity of cart item to specified value' do
        call
        expect(cart_item.quantity).to eq(4)
      end
    end

    context 'when quantity is negative number' do
      let(:quantity) { '-4' }

      it 'do not change quantity' do
        call
        expect(cart_item.quantity).to eq(1)
      end

      it 'do not set quantity as negative number' do
        call
        expect(cart_item.quantity).not_to eq(-4)
      end
    end

    context 'when quantity is not provided' do
      let(:quantity) { '' }

      it 'set quantity to 1' do
        call
        expect(cart_item.quantity).to eq(1)
      end

      it 'not setting empty value for quantity' do
        call
        expect(cart_item.quantity).not_to eq('')
      end
    end
  end
end
