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
      let!(:product2) { create(:product) }
      let(:cart_item) { create(:cart_item, shopping_cart: user.shopping_cart, product: product) }
      let(:cart_item2) { create(:cart_item, shopping_cart: user.shopping_cart, product: product2) }
      let(:cart_item3) { create(:cart_item, shopping_cart: user.shopping_cart, product: create(:product)) }
      let(:cart_items_params) do
        {
          cart_items: {
            cart_item.id => {
              quantity: '5'
            },
            cart_item2.id => {
              quantity: '10'
            }
          }
        }
      end

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

      it 'can change quantity of many products in shopping cart' do
        post '/cart', params: cart_items_params
        follow_redirect!
        expect(cart_item.reload.quantity).to eq(cart_items_params[:cart_items][cart_item.id][:quantity].to_i)
        expect(cart_item2.reload.quantity).to eq(cart_items_params[:cart_items][cart_item2.id][:quantity].to_i)
      end

      it 'removes product from shopping cart if quantity was set to zero' do
        expect(CartItem.where(id: cart_item3.id)).to exist
        post '/cart', params: { cart_items: { cart_item3.id => { quantity: '0' } } }
        follow_redirect!
        expect(CartItem.where(id: cart_item3.id)).not_to exist
      end
    end
  end
end
