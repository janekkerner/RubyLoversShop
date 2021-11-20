# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ShoppingCarts', type: :request do
  let!(:user) { create(:user, shopping_cart: create(:shopping_cart)) }
  let!(:product) { create(:product) }

  describe 'GET /cart' do
    it 'has redirect http status when user not sign in' do
      get '/cart'
      expect(response).to have_http_status(:redirect)
    end

    it 'has success http status when user signed in' do
      sign_in user
      get '/cart'
      expect(response).to have_http_status(:success)
    end

    it 'shows shopping cart if user is signed in' do
      sign_in user
      get '/cart'
      expect(response.body).to include('Your shopping cart is empty')
    end
  end

  describe 'POST /cart' do
    context 'when user is not signed in' do
      it 'redirect to sign in page if user not signed in' do
        post "/cart/#{product.id}"
        follow_redirect!
        expect(response.body).to include('You need to sign in or sign up before continuing.')
      end
    end

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

      it 'can add product to shopping cart' do
        expect do
          post "/cart/#{product.id}"
          follow_redirect!
        end
          .to change(user.shopping_cart.cart_items, :count)
      end
    end
  end
end
