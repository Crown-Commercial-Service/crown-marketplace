# frozen_string_literal: true

module Api
  module V2
    # return json
    class NutsController < FacilitiesManagement::FrameworkController
      protect_from_forgery with: :exception
      before_action :validate_service, :raise_if_not_live_framework, :redirect_to_buyer_detail, except: %i[show_post_code show_nuts_code find_region_query find_region_query_by_postcode]

      def show_post_code
        result = PostcodesNutsRegion.select(:id, :code, :postcode).find_by(postcode: params[:postcode].delete(' '))
        render json: { status: 200, result: result }
      rescue StandardError => e
        render json: { status: 404, error: e.to_s }
      end

      def show_nuts_code
        result = PostcodesNutsRegion.select(:id, :code, :postcode).find_by(code: params[:code])
        render json: { status: 200, result: result }
      rescue StandardError => e
        render json: { status: 404, error: e.to_s }
      end

      def find_region_query
        postcode_to_str = params['postcode'].to_s
        postcode_to_region = postcode_to_str[0, 3]

        result = Postcode::PostcodeCheckerV2.find_region postcode_to_region.delete(' ')
        render json: { status: 200, result: result }
      rescue StandardError => e
        render json: { status: 404, error: e.to_s }
      end

      def find_region_query_by_postcode
        postcode = params['postcode'].sub(' ', '')
        result = get_region_postcode postcode

        render json: { status: 200, result: result }
      rescue StandardError => e
        render json: { status: 404, error: e.to_s }
      end

      def get_region_by_outcode(postcode)
        original_postcode_to_region = postcode[0, 3]
        Postcode::PostcodeCheckerV2.find_region original_postcode_to_region.delete(' ')
      end

      def get_region_postcode(postcode)
        Postcode::PostcodeCheckerV2.find_region postcode
      end
    end
  end
end
