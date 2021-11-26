# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Pages', type: :request do
  describe 'GET /' do
    subject(:request) { get '/', params: params }

    let(:params) { {} }
    let(:product) { create(:product) }
    let(:product2) { create(:product) }
    let(:product3) { create(:product) }

    context 'with filter params provided' do
      let(:params) { { q: { price_gteq: product.price, price_lteq: product2.price } } }

      it 'have ok http status' do
        request
        expect(response).to have_http_status(:ok)
      end

      it 'filter products that belongs only to provided price range' do
        request
        expect(response.body).to include(product.name, product2.name)
        expect(response.body).not_to include(product3.name)
      end
    end
  end
end
