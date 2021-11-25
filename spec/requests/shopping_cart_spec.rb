# frozen_string_literal: true

require 'rails_helper'

# deeper nesting required for specified context
# rubocop:disable RSpec/NestedGroups

RSpec.describe 'ShoppingCarts', type: :request do
  let(:user) { create(:user, shopping_cart: create(:shopping_cart)) }

  describe 'GET /cart' do
    subject(:request) { get '/cart' }

    context 'when anonymous user visiting' do
      it 'has redirect http status' do
        request
        expect(response).to have_http_status(:redirect)
      end

      it 'shows log in page' do
        request
        follow_redirect!
        expect(response.body).to include('You need to sign in or sign up before continuing')
      end
    end

    context 'when user signed in' do
      before do
        sign_in user
      end

      it 'has success http status' do
        request
        expect(response).to have_http_status(:success)
      end

      it 'shows shopping cart' do
        request
        expect(response.body).to include('Your shopping cart is empty')
      end
    end
  end

  describe 'POST /cart' do
    subject(:request) { post '/cart', params: params }

    let!(:product) { create(:product) }
    let(:params) { { params: {} } }

    context 'when user is not signed in' do
      it 'redirect to sign in page' do
        request
        follow_redirect!
        expect(response.body).to include('You need to sign in or sign up before continuing.')
      end
    end

    context 'when user signed in' do
      subject(:request) { post '/cart', params: params }

      let(:cart_item) { create(:cart_item, shopping_cart: user.shopping_cart, product: product) }
      let(:cart_item2) { create(:cart_item, shopping_cart: user.shopping_cart, product: create(:product)) }
      let(:params) { {} }

      before do
        sign_in user
      end

      context 'with quantity provieded as hash for each cart item' do
        let(:params) do
          { cart_items: { cart_item.id => { quantity: '5' }, cart_item2.id => { quantity: '10' } } }
        end

        it 'can change quantity of many products in shopping cart' do
          request
          expect(cart_item.reload.quantity).to eq(params[:cart_items][cart_item.id][:quantity].to_i)
          expect(cart_item2.reload.quantity).to eq(params[:cart_items][cart_item2.id][:quantity].to_i)
        end
      end

      context 'with quantity provided as zero value' do
        let(:params) { { cart_items: { cart_item.id => { quantity: '0' } } } }

        it 'removes product from shopping cart if quantity was set to zero' do
          request
          expect(CartItem.where(id: cart_item.id)).not_to exist
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
