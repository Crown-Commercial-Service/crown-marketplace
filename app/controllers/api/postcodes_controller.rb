# frozen_string_literal: true

module Api
  # return json
  module V1
    class PostcodesController < ApplicationController
      protect_from_forgery with: :exception
      require_permission :none, only: :show

      # GET /postcodes/SW1A 2AA
      # GET /postcodes/SW1A 2AA.json
      #
      # usage:
      #      http://localhost:3000/api/v1/postcodes/SW1A%202AA
      #      http://localhost:3000/api/v1/postcodes/in_london?postcode=SW1P%202AP
      #      http://localhost:3000/api/v1/postcodes/in_london?postcode=G69%206HB
      def show
        result = query(params[:id])

        render json: { status: 200, result: result }
      rescue StandardError => e
        render json: { status: 404, error: e.to_s }
      end

      private

      def query(param)
        case param
        when 'in_london'
          PostcodeChecker.in_london? params[:postcode]
        else
          PostcodeChecker.location_info(param)
        end
      end
    end
  end
end
