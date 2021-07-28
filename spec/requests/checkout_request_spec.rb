# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Checkouts', type: :request do
  let!(:shopping_cart) { create(:shopping_cart) }
  let!(:user) { create(:user, shopping_cart: shopping_cart)}
  let!(:product) { create(:product) }

  describe 'GET /checkout' do
    it 'has redirect http status when user not sign in' do
      get '/checkout'
      expect(response).to have_http_status(:redirect)
    end

    context "when user signed in" do

      before do
        sign_in user
        user.shopping_cart.cart_items.create(product_id: product.id)
      end

      it 'is incrasing user order number after creating one' do
        expect do
          post '/checkout'
        end.to change(user.orders, :count).by(1)
      end

      it 'redirects to order show page after order has been set' do
        post '/checkout'
        follow_redirect!
        expect(response.body).to include("Order ID: #{user.orders.last.id}")
      end

      it 'shows shopping cart if order wasnt set' do
        get '/checkout'
        follow_redirect!
        expect(response.body).to include('You have 1 product in your shopping cart')
      end
    end
  end
end
