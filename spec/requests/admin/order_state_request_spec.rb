# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::Orders', type: :request do
  let!(:user) { create(:user) }
  let!(:order) { create(:order, user_id: user.id) }

  describe 'PATCH /admin/order/:id' do
    context 'when admin signed in' do
      let!(:admin) { create(:admin_user) }
      let!(:product) { create(:product) }

      before do
        sign_in admin
        create(:order_item, order_id: order.id, product_id: product.id)
      end

      it 'shows orders page with order state' do
        get "/admin/orders/#{order.id}"
        expect(response.body).to include(order.aasm_read_state.to_s)
      end

      it 'allows to change order status to failed' do
        patch "/admin/orders/#{order.shipment_id}/", params: { event: 'refuse' }
        follow_redirect!
        expect(response.body).to include('Order status has been updated to failed')
      end

      it 'not allows to change order status to failed if order is completed' do
        patch "/admin/payments/#{order.payment_id}/", params: { event: 'confirm' }
        patch "/admin/shipments/#{order.shipment_id}/", params: { event: 'prepare' }
        patch "/admin/shipments/#{order.shipment_id}/", params: { event: 'ship' }
        patch "/admin/orders/#{order.id}/", params: { event: 'complete' }
        follow_redirect!
        expect(response.body).to include('Order status has been updated to completed')
        patch "/admin/orders/#{order.id}/", params: { event: 'refuse' }
        follow_redirect!
        expect(response.body).to include('You are not allowed to do this operation')
      end

      it 'allows to change order status from new to completed if payment and shipment are completed' do
        patch "/admin/payments/#{order.payment_id}/", params: { event: 'confirm' }
        patch "/admin/shipments/#{order.shipment_id}/", params: { event: 'prepare' }
        patch "/admin/shipments/#{order.shipment_id}/", params: { event: 'ship' }
        patch "/admin/orders/#{order.id}/", params: { event: 'complete' }
        follow_redirect!
        expect(response.body).to include('Order status has been updated to completed')
      end

      it 'not allows to change order status from new to completed if shipment is not completed' do
        patch "/admin/payments/#{order.payment_id}/", params: { event: 'confirm' }
        patch "/admin/shipments/#{order.shipment_id}/", params: { event: 'prepare' }
        follow_redirect!
        expect(response.body).to include('Shipment status has been updated to ready')
        patch "/admin/orders/#{order.id}/", params: { event: 'complete' }
        follow_redirect!
        expect(response.body).to include('You are not allowed to do this operation')
      end
    end
  end
end
