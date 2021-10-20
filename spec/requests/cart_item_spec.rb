# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'CartItem', type: :request do
  let!(:user) { create(:user, shopping_cart: create(:shopping_cart)) }
  let!(:product) { create(:product) }

  describe 'POST /cart' do
    context 'when user signed in' do
      before do
        sign_in user
      end

      it 'has success http status' do
        post "/cart/#{product.id}"
        follow_redirect!
        expect(response).to have_http_status(:success)
      end

      it 'renders success notification after adding product to cart' do
        post "/cart/#{product.id}"
        follow_redirect!
        expect(response.body).to include("Product #{product.name} has been added to your shopping cart")
      end

      it 'can add product to shopping cart with specified quantity' do
        post "/cart/#{product.id}", params: { quantity: 5 }
        follow_redirect!
        expect(user.shopping_cart.cart_items.find_by(product_id: product.id).quantity).to eq(5)
      end

      it 'increase quantity of cart item if same product is added to shopping cart' do
        2.times do
          post "/cart/#{product.id}"
          follow_redirect!
        end
        expect(user.shopping_cart.cart_items.find_by(product_id: product.id).quantity).to eq(2)
      end

      it 'increase quantity of cart item by given number if product is already in cart' do
        2.times do
          post "/cart/#{product.id}"
        end
        post "/cart/#{product.id}", params: { quantity: 5 }
        follow_redirect!
        expect(user.shopping_cart.cart_items.find_by(product_id: product.id).quantity).to eq(7)
      end

      it 'not allows to provide not numerical value' do
        post "/cart/#{product.id}", params: { quantity: 'a' }
        follow_redirect!
        expect(response.body).to include('Quantity is not a number')
      end

      it 'convert quantity nil value to quantity equals one' do
        post "/cart/#{product.id}", params: { quantity: nil }
        follow_redirect!
        expect(user.shopping_cart.cart_items.find_by(product_id: product.id).quantity).to eq(1)
      end

      it 'convert quantity nil value to quantity equals one when product already in cart' do
        post "/cart/#{product.id}", params: { quantity: nil }
        follow_redirect!
        expect do
          post "/cart/#{product.id}", params: { quantity: nil }
          follow_redirect!
        end
          .to change { user.shopping_cart.cart_items.find_by(product_id: product.id).quantity }.by(1)
      end
    end
  end
end
