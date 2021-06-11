# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Authentications', type: :system do
  let(:user) { build(:user) }
  let(:user2) { create(:user) }

  before do
    driven_by(:rack_test)
  end

  describe 'when user is visiting sign up page' do
    it 'can create a new account' do
      visit new_user_registration_path
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: user.password
      fill_in 'user_password_confirmation', with: user.password
      click_button 'Sign up'
      expect(page).to have_text('Welcome! You have signed up successfully.')
    end

    it 'can not create new account with already taken email' do
      visit new_user_registration_path
      fill_in 'user_email', with: user2.email
      fill_in 'user_password', with: user2.password
      fill_in 'user_password_confirmation', with: user2.password
      click_button 'Sign up'
      expect(page).to have_text('Email has already been taken')
    end
  end
end
