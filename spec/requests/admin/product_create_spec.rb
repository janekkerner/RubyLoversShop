# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::Products', type: :request do
  let!(:admin) { create(:admin_user) }
  let!(:category) { create(:category) }

  describe 'GET /admin/products/new' do
    it 'have ok http status' do
      sign_in admin
      get '/admin/products/new'
      expect(response).to have_http_status(:ok)
    end

    it 'redirect if admin not sign in' do
      get '/admin/products/new'
      expect(response).to have_http_status(:redirect)
    end

    it 'renders correct content' do
      sign_in admin
      get '/admin/products/new'
      expect(response.body).to include('Create product')
    end
  end

  describe 'POST /admin/products' do
    before do
      sign_in admin
    end

    it 'create product with given params' do
      product_params = attributes_for(:product)
      expect do
        post '/admin/products', params: { product: product_params.merge(category_id: category.id) }
      end
        .to change(Product.all, :count).by(1)
    end

    it 'doesnt create product with empty name param' do
      product_params = attributes_for(:product, name: '')
      expect do
        post '/admin/products', params: { product: product_params.merge(category_id: category.id) }
      end
        .not_to change(Product.all, :count)
    end

    it 'doesnt create product with empty price param' do
      product_params = attributes_for(:product, price: '')
      expect do
        post '/admin/products', params: { product: product_params.merge(category_id: category.id) }
      end
        .not_to change(Product.all, :count)
    end
  end
end
