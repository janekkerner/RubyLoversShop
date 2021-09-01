# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::Order', type: :system do
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

  describe 'when signed in user is visiting order page' do
    it 'is redirected to admin sign in page' do
      sign_in user
      visit admin_order_path(order.id)
      expect(page).to have_text('Log in as Admin')
    end
  end

  describe 'when admin user is visiting order page on admin panel' do
    let!(:admin) { create(:admin_user) }
    let!(:product) { create(:product) }

    before do
      sign_in admin
      create(:order_item, product_id: product.id, order_id: order.id)
      visit admin_order_path(order.id)
    end

    it 'can see order status with new value' do
      within '#order_state_card' do
        expect(page).to have_text('Current order status: new')
      end
    end

    it 'can change order status from new to failed on order page' do
      within '#order_state_card' do
        click_link 'refuse'
        expect(page).to have_text('Current order status: failed')
      end
    end

    it 'cannot change order status from new to completed if payment and shipment are not completed' do
      within '#order_state_card' do
        expect(page).not_to have_link('complete')
      end
    end

    it 'cannot change order status from new to completed if only payment is completed' do
      within '#payment_card' do
        click_link 'confirm'
      end
      within '#order_state_card' do
        expect(page).not_to have_link('complete')
      end
    end

    it 'can change order status from new to completed on order page if payment and shipment are completed' do
      within '#payment_card' do
        click_link 'confirm'
      end
      within '#shipment_card' do
        click_link 'prepare'
        click_link 'ship'
      end
      within '#order_state_card' do
        expect(page).to have_link('complete')
      end
    end

    it 'cannot change order status from completed to failed' do
      within '#payment_card' do
        click_link 'confirm'
      end
      within '#shipment_card' do
        click_link 'prepare'
        click_link 'ship'
      end
      within '#order_state_card' do
        click_link 'complete'
        expect(page).not_to have_link('refuse')
      end
    end
  end
end
