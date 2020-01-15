# frozen_string_literal: true

module Api
  module V1
    # return json
    class NutsController < ApplicationController
      protect_from_forgery with: :exception
      before_action :authenticate_user!

      def show_post_code
        result = PostcodesNutsRegions.select(:id, :code, :postcode).find_by(postcode: params[:postcode].delete(' '))
        render json: { status: 200, result: result }
      rescue StandardError => e
        render json: { status: 404, error: e.to_s }
      end

      def show_nuts_code
        result = PostcodesNutsRegions.select(:id, :code, :postcode).find_by(code: params[:code])
        render json: { status: 200, result: result }
      rescue StandardError => e
        render json: { status: 404, error: e.to_s }
      end

      def find_region_query
        postcode_to_str = params['postcode'].to_s
        postcode_to_region = postcode_to_str[0, 3]
        postcode_to_region_rm_white_space = postcode_to_region.delete(' ')

        result = Postcode::PostcodeChecker.find_region postcode_to_region_rm_white_space
        render json: { status: 200, result: result }
      rescue StandardError => e
        render json: { status: 404, error: e.to_s }
      end
    end
  end
end
