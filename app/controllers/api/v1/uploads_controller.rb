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

        data = JSON.parse(request.body.read) unless request.body.read.size.zero?

        query(action, data)
      end

      # ---------------------------
      # private

      def query(action, data)
        case action
        when 'clear'
          Postcode::PostcodeChecker.clear
        when 'count'
          Postcode::PostcodeChecker.count
        when 'upload'
          Postcode::PostcodeChecker.upload(data['AccessKeyId'], data['SecretAccessKey'], data['bucket'], data['region'])
        else
          raise "unknown action #{action}"
        end
      end
    end
  end
end
