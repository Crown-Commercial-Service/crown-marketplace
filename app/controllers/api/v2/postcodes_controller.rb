# frozen_string_literal: true

module Api
  # return json
  module V2
    class PostcodesController < FacilitiesManagement::FrameworkController
      protect_from_forgery with: :exception
      before_action :validate_service, :raise_if_not_live_framework, :redirect_to_buyer_detail, except: :show

      # GET /postcodes/SW1A 2AA
      # GET /postcodes/SW1A 2AA.json
      #
      # usage:
      #      http://localhost:3000/api/v2/postcodes/SW1A%202AA
      #      http://localhost:3000/api/v2/postcodes/in_london?postcode=SW1P%202AP
      #      http://localhost:3000/api/v2/postcodes/in_london?postcode=G69%206HB
      def show
        result = query(params[:id])
        render json: { status: 200, result: result.to_a }
      rescue StandardError => e
        render json: { status: 404, error: e.to_s }
      end

      private

      def query(param)
        Postcode::PostcodeCheckerV2.location_info(param.to_s.upcase)
      end
    end
  end
end
