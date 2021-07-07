# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Dashboards', type: :system do
  let!(:admin) { create(:admin_user) }
  let!(:user) { create(:user) }

  before do
    driven_by(:rack_test)
  end

  describe 'when anonymous user is visiting admin page' do
    it 'is redirected to admin sign in page' do
      visit admin_path
      expect(page).to have_text('Log in as Admin')
    end
  end

  describe 'when admin user is visitin admin page' do
    it 'can see admin dashboard' do
      sign_in admin
      visit admin_path
      expect(page).to have_text('Admin dashboard')
      sign_out admin
    end
  end

  describe 'when signed in user is visiting admin page' do
    it 'is redirected to root path with alert text' do
      sign_in user
      visit admin_path
      expect(page).to have_text('You are not authorize.')
      sign_out user
    end

    it 'cannot see admin dashboard' do
      sign_in user
      visit admin_path
      expect(page).not_to have_text('Admin dashboard')
    end
  end
end
