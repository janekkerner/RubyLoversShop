# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Dashboards', type: :system do
  let!(:admin) { create(:admin_user) }
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

  describe 'when admin user is visiting admin page' do
    before do
      sign_in admin
      visit admin_order_path(order.id)
    end

    it 'can see order page' do
      expect(page).to have_text("Order ID: #{order.id}")
      sign_out admin
    end

    it 'can see orders state' do
      expect(page).to have_text("Order state: #{order.state}")
    end

    it 'can see orders date' do
      expect(page).to have_text("Created at: #{order.created_at.strftime('%T %F').to_s}")
    end

    it 'can see orders total price' do
      expect(page).to have_text(order.total_price.to_s)
    end
  end
end
