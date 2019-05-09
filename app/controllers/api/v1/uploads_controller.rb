# frozen_string_literal: true

module Api
  module V1
    # return json
    class UploadsController < ApplicationController
      protect_from_forgery with: :exception
      require_permission :none, only: :show
      skip_before_action :verify_authenticity_token, only: :show

      # :nocov:
      if Rails.env.production?
        http_basic_authenticate_with(
          name: Marketplace.http_basic_auth_name,
          password: Marketplace.http_basic_auth_password
        )
      end
      # :nocov:

      # usage:
      # curl  --request POST   --header "Content-Type: application/json" --data @aws-secrets.json http://localhost:3000/api/v1/postcode/upload
      def show
        action = params[:id]

        data = JSON.parse(request.body.read)

        query(action, data)

        render json: {}, status: :created
      rescue StandardError => e
        render json: { error: e.to_s }, status: 404
      end

      # ---------------------------
      # private

      def query(action, data)
        case action
        when 'clear'
          PostcodeChecker.clear
        when 'count'
          PostcodeChecker.count
        when 'upload'
          upload(data[:access_key], data[:secret_access_key], data[:bucket], data[:region])
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
