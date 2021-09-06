# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::Orders', type: :request do
  let!(:user) { create(:user) }
  let!(:order) { create(:order, user_id: user.id) }

  describe 'GET /admin/orders' do
    context 'when admin not signed in' do
      it 'redirects to admin log in' do
        get '/admin/orders'
        expect(response).to have_http_status(:redirect)
        follow_redirect!
        expect(response.body).to include('Log in as Admin')
      end
    end

    context 'when admin signed in' do
      let!(:admin) { create(:admin_user) }

      before do
        sign_in admin
      end

      it 'shows orders page' do
        get '/admin/orders'
        expect(response.body).to include 'Orders:'
      end

      it 'has a 200 status' do
        get '/admin/orders'
        expect(response).to have_http_status('200')
      end

      it 'shows order id, status and total_price' do
        get '/admin/orders'
        expect(response.body).to include order.id.to_s
        expect(response.body).to include order.state.to_s
        expect(response.body).to include order.total_price.to_s
      end
    end
  end
end
