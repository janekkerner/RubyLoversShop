require 'rails_helper'

RSpec.describe "Authentications", type: :system do
  let(:user) { create(:user) }
  let(:user2) { build(:user) }
  before do
    driven_by(:rack_test)
  end

  describe "when user visit log in page" do
    it "can reset his password" do
      visit new_user_session_path
      click_link "Forgot your password?"
      fill_in "user_email", with: user.email
      click_button "Send me reset password instructions"
      expect(page).to have_text("You will receive an email with instructions on how to reset your password in a few minutes.")
      p
    end
    it 'cannot reset password for not existing user' do
      visit new_user_session_path
      click_link "Forgot your password?"
      fill_in "user_email", with: user2.email
      click_button "Send me reset password instructions"
      expect(page).to have_text("Email not found")
    end
  end
end
