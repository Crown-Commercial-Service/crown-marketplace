# frozen_string_literal: true

module Api
  # return json
  module V2
    class PostcodesController < ApplicationController
      protect_from_forgery with: :exception
      before_action :authenticate_user!, except: :show

      # GET /postcodes/SW1A 2AA
      # GET /postcodes/SW1A 2AA.json
      #
      # usage:
      #      http://localhost:3000/api/v2/postcodes/SW1A%202AA
      #      http://localhost:3000/api/v2/postcodes/in_london?postcode=SW1P%202AP
      #      http://localhost:3000/api/v2/postcodes/in_london?postcode=G69%206HB
      def show
        result = query(params[:id])
        render json: { status: 200, result: result.to_hash }
      rescue StandardError => e
        render json: { status: 404, error: e.to_s }
      end

      private

      def query(param)
        Postcode::PostcodeChecker_V2.location_info(param)
      end
    end
  end
end
