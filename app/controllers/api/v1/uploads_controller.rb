
# frozen_string_literal: true

module Api
  module V1
    # return json
    class UploadsController < ApplicationController
      protect_from_forgery with: :exception
      require_permission :none, only: %i[create show]
      skip_before_action :verify_authenticity_token, only: %i[create show]


      # :nocov:
      if Rails.env.production?
        http_basic_authenticate_with(
            name: Marketplace.http_basic_auth_name,
            password: Marketplace.http_basic_auth_password
        )
      end
      # :nocov:

      # usage:
      # curl  --request POST --header "Content-Type: application/json" --data @aws-secrets.json http://localhost:3000/api/v1/postcode?x=y
      def show
        action = params[:id]

        data = JSON.parse(request.body.read)



        render json: {}, status: :created
      rescue StandardError => e
        render json: { error: e.to_s }, status: 404
      end

      # ---------------------------
      # private

      def query(param)
        case param
        when 'in_london'
          PostcodeChecker.in_london? params[:postcode]
        when 'clear'
          PostcodeChecker.clear(params[:access_key], params[:secret_access_key])
        when 'count'
          PostcodeChecker.count(params[:access_key], params[:secret_access_key])
        when 'upload'
          upload(params[:access_key], params[:secret_access_key], params[:bucket], params[:region])
        else
          PostcodeChecker.location_info(param)
        end
      end

      def upload(access_key, secret_access_key, bucket, region)
        flag = PostcodeChecker.table_exists
        if flag
          rows = PostcodeChecker.count(access_key, secret_access_key)
          return "There are already #{rows} rows of postcodes data! Please clear that data first.\n" unless rows.zero?
        end
        PostcodeChecker.upload(access_key, secret_access_key, bucket, region)
      end

    end

  end
end
