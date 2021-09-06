# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Dashboards', type: :system do
  let!(:user) { create(:user) }
  let!(:order) { create(:order, user_id: user.id) }

  before do
    driven_by(:rack_test)
  end

  describe 'when anonymous user is visiting order page' do
    it 'is redirected to admin sign in page' do
      visit admin_order_path(order.id)
      expect(page).to have_text('Log in as Admin')
    end
  end

  describe 'when admin user is visiting' do
    let!(:admin) { create(:admin_user) }
    let!(:product) { create(:product) }

    context 'with orders list on admin panel' do
      it 'can go to selected order page' do
        create(:order_item, product_id: product.id, order_id: order.id)
        sign_in admin
        visit admin_orders_path
        within 'table' do
          click_link 'show', match: :first
        end
        expect(page).to have_text("Order ID: #{Order.last.id}")
      end
    end

    context 'with order page on admin panel' do
      before do
        sign_in admin
        create(:order_item, product_id: product.id, order_id: order.id)
        visit admin_order_path(order.id)
      end

      it 'can see order page' do
        expect(page).to have_text("Order ID: #{order.id}")
        sign_out admin
      end

      it 'can see order products name' do
        expect(page).to have_text(order.products.first.name.to_s)
      end

      it 'can see order products price' do
        expect(page).to have_text(order.products.first.price.to_s)
      end

      it 'can see order state' do
        expect(page).to have_text("Order state: #{order.state}")
      end

      it 'can see order date' do
        expect(page).to have_text("Created at: #{order.created_at.strftime('%T %F')}")
      end

      it 'can see order total price' do
        expect(page).to have_text(order.total_price.to_s)
      end

      it 'can see order user email' do
        expect(page).to have_text("E-mail: #{order.user.email}")
      end
    end
  end
end
