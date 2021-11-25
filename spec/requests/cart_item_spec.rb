# frozen_string_literal: true

require 'rails_helper'

# deeper nesting required for specified context
# rubocop:disable RSpec/NestedGroups

RSpec.describe 'CartItem', type: :request do
  let!(:user) { create(:user, shopping_cart: create(:shopping_cart)) }
  let!(:product) { create(:product) }

  describe 'POST /cart/:id' do
    subject(:request) do
      post "/cart/#{product.id}", params: params
      follow_redirect!
    end

    let(:params) { {} }

    context 'when user logged in' do
      before do
        sign_in user
      end

      context 'with no quantity params provided' do
        it 'has success http status' do
          request
          expect(response).to have_http_status(:success)
        end

        it 'renders success notification after adding product to cart' do
          request
          expect(response.body).to include("Product #{product.name} has been added to your shopping cart")
        end

        it 'adds product to shopping cart' do
          request
          expect(user.shopping_cart.cart_items.find_by(product_id: product.id).quantity).to eq(1)
        end

        it 'increase quantity of cart item if same product is added to shopping cart' do
          request
          post "/cart/#{product.id}"
          expect(user.shopping_cart.cart_items.find_by(product_id: product.id).quantity).to eq(2)
        end
      end

      context 'with quantity param as specified number value' do
        let(:params) { { quantity: 5 } }

        it 'can add product to shopping cart with specified quantity' do
          request
          expect(user.shopping_cart.cart_items.find_by(product_id: product.id).quantity).to eq(5)
        end

        it 'increase quantity of cart item by given number if product is already in cart' do
          request
          post "/cart/#{product.id}", params: { quantity: 5 }
          follow_redirect!
          expect(user.shopping_cart.cart_items.find_by(product_id: product.id).quantity).to eq(10)
        end
      end

      context 'with quantity param as non-numerical value' do
        let(:params) { { quantity: 'a' } }

        it 'not allows to provide not numerical value' do
          request
          expect(response.body).to include('Quantity is not a number')
        end
      end

      context 'with quantity param as nil value' do
        let(:params) { { quantity: nil } }

        it 'convert quantity nil value to quantity equals one' do
          request
          expect(user.shopping_cart.cart_items.find_by(product_id: product.id).quantity).to eq(1)
        end

        it 'convert quantity nil value to quantity equals one when product already in cart' do
          request
          expect do
            post "/cart/#{product.id}", params: params
            follow_redirect!
          end
            .to change { user.shopping_cart.cart_items.find_by(product_id: product.id).quantity }.by(1)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
