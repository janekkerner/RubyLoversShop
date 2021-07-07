# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::Product#update', type: :request do
  let!(:admin) { create(:admin_user) }
  let!(:product) { create(:product) }

  describe 'GET /admin/products/:id/edit' do
    it 'have ok http status' do
      sign_in admin
      get "/admin/products/#{product.id}/edit"
      expect(response).to have_http_status(:ok)
    end

    it 'redirect if admin not sign in' do
      get "/admin/products/#{product.id}/edit"
      expect(response).to have_http_status(:redirect)
    end

    it 'renders sign in view if admin not sign in' do
      get "/admin/products/#{product.id}/edit"
      follow_redirect!
      expect(response.body).to include('You need to sign in or sign up before continuing.')
    end

    it 'renders correct content' do
      sign_in admin
      get "/admin/products/#{product.id}/edit"
      expect(response.body).to include("Edit product | ID: #{product.id}")
    end
  end
end
