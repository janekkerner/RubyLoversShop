# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Authentications', type: :system do
  before do
    driven_by(:rack_test)
  end

  describe 'when user is visiting different pages' do
    it 'can log in with link from root path' do
      visit root_path
      click_link 'Log in'
      expect(page).to have_selector('h2', text: 'Log in')
    end

    it 'can log in with link from sign up page' do
      visit new_user_registration_path
      click_link 'Log in', match: :first
      expect(page).to have_selector('h2', text: 'Log in')
    end
  end
end
