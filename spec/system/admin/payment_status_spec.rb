# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Dashboards', type: :system do
  let!(:user) { create(:user) }
  let!(:order) { create(:order, user_id: user.id) }

  before do
    driven_by(:rack_test)
  end

  describe 'when anononimous user is visiting order page' do
    it 'is redirected to admin sign in page' do
      visit admin_order_path(order.id)
      expect(page).to have_text('Log in as Admin')
    end
  end

  describe 'when user is visiting order page' do
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

    it 'can see payment status with pending value' do
      expect(page).to have_text('Current payment status: pending')
    end

    it 'can change payment status from pending to completed on order page' do
      within '#payment_card' do
        click_link 'confirm'
        expect(page).to have_text('Current payment status: completed')
      end
    end

    it 'can change payment status from pending to failed on order page' do
      within '#payment_card' do
        click_link 'reject'
        expect(page).to have_text('Current payment status: failed')
      end
    end

    it 'cannot change payment status from failed to any other status' do
      within '#payment_card' do
        click_link 'reject'
        expect(page).not_to have_link('confirm')
        expect(page).not_to have_link('reject')
      end
    end
  end
end
