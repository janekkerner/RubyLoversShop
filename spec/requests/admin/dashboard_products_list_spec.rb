# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::Dashboards', type: :request do
  let!(:admin) { create(:admin_user) }
  let!(:product) { create(:product) }

  describe 'GET admin/dashboards' do
    it 'renders index view' do
      sign_in admin
      get '/admin/dashboard'
      expect(response).to have_http_status(:ok)
    end

    it 'renders products' do
      sign_in admin
      get '/admin/dashboard'
      expect(response.body).to include product.name
    end
  end
end
