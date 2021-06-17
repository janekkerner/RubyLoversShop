# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Authentications', type: :system do
  let(:user) { create(:user) }
  let(:user2) { build(:user) }

  before do
    driven_by(:rack_test)
  end

  describe 'when user is visiting log in page' do
    it 'can log in into his account' do
      visit new_user_session_path
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: user.password
      click_button 'Log in'
      expect(page).to have_text('Signed in successfully.')
    end

    it 'cannot log in into account when user doesnt exist' do
      visit new_user_session_path
      fill_in 'user_email', with: user2.email
      fill_in 'user_password', with: user2.password
      click_button 'Log in'
      expect(page).to have_text('Invalid Email or password.')
    end
  end
end
