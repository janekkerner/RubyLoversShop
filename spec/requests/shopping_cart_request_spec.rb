# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ShoppingCarts', type: :request do
  let!(:user) { create(:user) }

  describe 'GET /cart' do
    it 'has redirect http status when user not sign in' do
      get '/cart'
      expect(response).to have_http_status(:redirect)
    end

    it 'has success http status when user signed in' do
      sign_in user
      get '/cart'
      expect(response).to have_http_status(:success)
    end

    it 'shows shopping cart if user is signed in' do
      sign_in user
      get '/cart'
      expect(response.body).to include('Your shopping cart is empty')
    end
  end
end
