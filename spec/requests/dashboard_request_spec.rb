require 'rails_helper'

RSpec.describe "Dashboards", type: :request do
  let!(:admin) { create(:admin_user) }
  let!(:user) { create(:user) }

  describe "GET /admin" do
    it "redirects to admin log in" do
      get admin_path
      expect(response).to have_http_status(:redirect)
    end

    it 'shows flash alert with login requirement info' do
      get admin_path
      follow_redirect!
      expect(response.body).to include 'You need to sign in or sign up before continuing.'
    end

    it 'denied access to admin dashboard for logged in user' do
      sign_in user
      get admin_path
      follow_redirect!
      expect(response.body).to include 'You are not authorize.'
      sign_out user
    end

    it 'give access to admin dashboard for logged in admin' do
      sign_in admin
      get admin_path
      expect(response.body).to include 'Admin dashboard'
    end
  end
end
