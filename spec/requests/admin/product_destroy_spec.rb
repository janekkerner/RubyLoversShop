# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::Products', type: :request do
  let!(:admin) { create(:admin_user) }
  let!(:product) { create(:product) }

  before do
    sign_in admin
  end

  describe 'DELETE /admin/products' do
    it 'have redirect http status' do
      delete admin_product_path(product)
      expect(response).to have_http_status(:redirect)
    end

    it 'removes choosen product' do
      delete admin_product_path(product)
      follow_redirect!
      expect(response.body).to include("Product with ID: #{product.id} has been deleted")
    end

    it 'removes choosen product and check with products number' do
      expect do
        delete admin_product_path(product)
      end
        .to change(Product.all, :count).by(-1)
    end

    it 'not remove product when admin is not signed in' do
      sign_out admin
      expect do
        delete admin_product_path(product)
      end
        .not_to change(Product.all, :count)
    end
  end
end
