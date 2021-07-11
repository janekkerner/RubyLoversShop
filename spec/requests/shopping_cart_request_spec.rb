require 'rails_helper'

RSpec.describe "ShoppingCarts", type: :request do

  describe "GET /show" do
    it "returns http success" do
      get "/shopping_cart/show"
      expect(response).to have_http_status(:success)
    end
  end

end
