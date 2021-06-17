# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Authentications', type: :system do
  let(:user) { create(:user) }

  before do
    driven_by(:rack_test)
  end

  describe 'when user is visiting different pages' do
    it 'can log out with link if loged in before' do
      sign_in user
      visit root_path
      click_link 'Log out', match: :first
      expect(page).to have_text('Signed out successfully.')
    end

    it 'can log in with link from sign up page' do
      sign_in user
      visit new_user_registration_path
      click_link 'Log out', match: :first
      expect(page).to have_text('Signed out successfully.')
    end
  end
end
