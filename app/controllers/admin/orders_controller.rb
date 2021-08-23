# frozen_string_literal: true

module Admin
  class OrdersController < ApplicationController
    before_action :authenticate_admin_user!

    layout 'dashboard'

    def index
      @pagy, @records = pagy(Order.order('created_at DESC'))
      render :index, locals: { orders: @records, pagy: @pagy }
    end
  end
end
