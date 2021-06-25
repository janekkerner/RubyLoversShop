require 'rails_helper'

RSpec.describe "Dashboards", type: :request do
  let!(:admin) { create(:admin_user) }

  describe "GET admin/dashboards" do
    it "renders index view" do
      sign_in admin
      get '/admin/dashboard'
      expect(response).to have_http_status(200)
    end

    it "" do

    end
  end
end
