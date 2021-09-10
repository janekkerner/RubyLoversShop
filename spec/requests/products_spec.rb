# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Products', type: :request do
  describe 'GET /products/:id' do
    context 'when user visiting product page' do
      let!(:product) { create(:product) }

      before do
        get "/products/#{product.id}"
      end

      it 'have ok http status' do
        expect(response).to have_http_status(:ok)
      end

      it 'have product name' do
        expect(response.body).to include(product.name)
      end

      it 'have product price' do
        expect(response.body).to include(product.price.to_s)
      end

      it 'have product description' do
        expect(response.body).to include('This is a place for product description')
      end
    end
  end
end
