# frozen_string_literal: true

module Admin
  class DashboardsController < ApplicationController
    before_action :check_user
    before_action :authenticate_admin_user!

    layout 'dashboard'

    def index
    end

    private

    def check_user
      if user_signed_in?
        flash[:alert] = 'You are not authorize.'
        redirect_to root_path
      end
    end
  end
end
