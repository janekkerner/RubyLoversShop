# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::Shipment', type: :system do
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

  describe 'when logged in user is visiting order page' do
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

    it 'can see shipment status with pending value' do
      within '#shipment_card' do
        expect(page).to have_text('Current shipment status: pending')
      end
    end

    it 'can change shipment status from pending to ready on order page' do
      within '#shipment_card' do
        click_link 'prepare'
        expect(page).to have_text('Current shipment status: ready')
      end
    end

    it 'can change shipment status from pending to canceled on order page' do
      within '#shipment_card' do
        click_link 'cancel'
        expect(page).to have_text('Current shipment status: canceled')
      end
    end

    it 'cannot change shipment status from ready to shipped on order page if payment not completed' do
      within '#shipment_card' do
        click_link 'prepare'
        expect(page).not_to have_link('ship')
      end
    end

    it 'can change shipment status from ready to shipped on order page if payment is completed' do
      within '#payment_card' do
        click_link 'confirm'
      end
      within '#shipment_card' do
        click_link 'prepare'
        click_link 'ship'
        expect(page).to have_text('Current shipment status: shipped')
      end
    end

    it 'can change shipment status from ready to failed on order page' do
      within '#shipment_card' do
        click_link 'prepare'
        click_link 'fail'
        expect(page).to have_text('Current shipment status: failed')
      end
    end

    it 'cannot change shipment status from pending to shipped or failed' do
      within '#shipment_card' do
        expect(page).not_to have_link('ship')
        expect(page).not_to have_link('fail')
      end
    end
  end
end
