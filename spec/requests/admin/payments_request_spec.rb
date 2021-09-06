# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::Payments', type: :request do
  let!(:user) { create(:user) }
  let!(:order) { create(:order, user_id: user.id) }

  describe 'GET /admin/orders/:id' do
    context 'when admin not signed in' do
      it 'redirects to admin log in' do
        get "/admin/orders/#{order.id}"
        expect(response).to have_http_status(:redirect)
        follow_redirect!
        expect(response.body).to include('Log in as Admin')
      end
    end

    context 'when user signed in' do
      it 'redirects to admin log in' do
        sign_in user
        get "/admin/orders/#{order.id}"
        expect(response).to have_http_status(:redirect)
        follow_redirect!
        expect(response.body).to include('Log in as Admin')
      end
    end

    context 'when admin signed in' do
      let!(:admin) { create(:admin_user) }
      let!(:product) { create(:product) }

      before do
        sign_in admin
        create(:order_item, order_id: order.id, product_id: product.id)
      end

      it 'shows orders page with payment state' do
        get "/admin/orders/#{order.id}"
        expect(response.body).to include(order.payment.aasm_state.to_s)
      end

      it 'allows to change order payment status to completed' do
        patch "/admin/payments/#{order.payment.id}/", params: { event: 'confirm' }
        follow_redirect!
        expect(response.body).to include('completed')
      end

      it 'allows to change order payment status to failed' do
        patch "/admin/payments/#{order.payment.id}/", params: { event: 'reject' }
        follow_redirect!
        expect(response.body).to include('failed')
      end

      it 'not allows to change order payment status from failed to completed' do
        patch "/admin/payments/#{order.payment.id}/", params: { event: 'reject' }
        follow_redirect!
        expect(response.body).to include('failed')
        patch "/admin/payments/#{order.payment.id}/", params: { event: 'confirm' }
        follow_redirect!
        expect(response.body).to include('You are not allowed to do this operation')
      end

      it 'not allows to change order payment status from completed to failed' do
        patch "/admin/payments/#{order.payment.id}/", params: { event: 'confirm' }
        follow_redirect!
        expect(response.body).to include('completed')
        patch "/admin/payments/#{order.payment.id}/", params: { event: 'reject' }
        follow_redirect!
        expect(response.body).to include('You are not allowed to do this operation')
      end
    end
  end
end
