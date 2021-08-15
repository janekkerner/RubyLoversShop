# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::Orders', type: :request do
  let!(:admin) { create(:admin_user) }
  let!(:user) { create(:user) }
  let!(:order) { create(:order, user_id: user.id) }
  let!(:product) { create(:product) }

  describe 'GET /admin/orders/:id' do
    context 'when admin not signed in' do
      it 'redirects to admin log in' do
        get "/admin/orders/#{order.id}"
        expect(response).to have_http_status(:redirect)
        follow_redirect!
        expect(response.body).to include('Log in as Admin')
      end
    end

    context 'when admin signed in' do
      before do
        sign_in admin
        create(:order_item, order_id: order.id, product_id: product.id)
        get "/admin/orders/#{order.id}"
      end

      it 'shows orders page' do
        expect(response.body).to include "Order ID: #{order.id}"
      end

      it 'has a 200 status' do
        expect(response).to have_http_status('200')
      end

      it 'shows order id, status and total_price' do
        expect(response.body).to include order.id.to_s
        expect(response.body).to include order.user.email.to_s
        expect(response.body).to include order.products.first.name.to_s
        expect(response.body).to include order.products.first.price.to_s
        expect(response.body).to include order.state.to_s
        expect(response.body).to include order.total_price.to_s
      end
    end
  end
end
