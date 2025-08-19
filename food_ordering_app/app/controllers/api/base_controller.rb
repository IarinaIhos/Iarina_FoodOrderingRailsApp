# app/controllers/api/base_controller.rb
class Api::BaseController < ApplicationController
    skip_before_action :verify_authenticity_token
        
    private

    def current_api_user
        current_user
    end
  end
