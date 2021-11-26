# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Pages', type: :request do
  describe 'GET /' do
    subject(:request) { get '/' }
    create_list(:product, 4)

    it 'have ok http status' do
      expect(request).to have_http_status(:ok)
    end

    it 'have product description' do
      expect(response.body).to include('This is a place for product description')
    end
  end
end
