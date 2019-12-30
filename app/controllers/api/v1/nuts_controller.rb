# frozen_string_literal: true
module Api
  module V1
    # return json
    class NutsController < ApplicationController
      protect_from_forgery with: :exception
      
      def show_post_code
        result = PostcodesNutsRegions.select(:id, :code, :postcode).find_by(postcode:params[:postcode])
        render json: { status: 200, result: result }
      rescue StandardError => e
        render json: { status: 404, error: e.to_s }
      end
      def show_nuts_code
        result = PostcodesNutsRegions.select(:id, :code, :postcode).find_by(code:params[:code])
        render json: { status: 200, result: result }
      rescue StandardError => e
        render json: { status: 404, error: e.to_s }
      end      
    end
  end
end
