# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::Shipments', type: :request do
  let!(:user) { create(:user) }
  let!(:order) { create(:order, user_id: user.id) }

  describe 'GET /admin/order/:id' do
    context 'when admin signed in' do
      let!(:admin) { create(:admin_user) }
      let!(:product) { create(:product) }

      before do
        sign_in admin
        create(:order_item, order_id: order.id, product_id: product.id)
      end

      it 'shows orders page with shipment state' do
        get "/admin/orders/#{order.id}"
        expect(response.body).to include(order.shipment.aasm_state.to_s)
      end

      it 'allows to change order shipment status to ready' do
        patch "/admin/shipments/#{order.shipment_id}/", params: { event: 'prepare' }
        follow_redirect!
        expect(response.body).to include('ready')
      end

      it 'allows to change order shipment status to failed' do
        patch "/admin/shipments/#{order.shipment_id}/", params: { event: 'prepare' }
        patch "/admin/shipments/#{order.shipment_id}/", params: { event: 'fail' }
        follow_redirect!
        expect(response.body).to include('failed')
      end

      it 'not allows to change order shipment status from ready to completed if payment is not completed' do
        patch "/admin/shipments/#{order.shipment_id}/", params: { event: 'prepare' }
        patch "/admin/shipments/#{order.shipment_id}/", params: { event: 'ship' }
        follow_redirect!
        expect(response.body).to include('You are not allowed to do this operation')
      end

      it 'not allows to change order payment status from ready to completed if payment is completed' do
        patch "/admin/payments/#{order.payment_id}/", params: { event: 'confirm' }
        follow_redirect!
        expect(response.body).to include('completed')
        patch "/admin/shipments/#{order.shipment_id}/", params: { event: 'prepare' }
        patch "/admin/shipments/#{order.shipment_id}/", params: { event: 'ship' }
        follow_redirect!
        expect(response.body).to include('Shipment status has been updated to shipped')
      end
    end
  end
end
