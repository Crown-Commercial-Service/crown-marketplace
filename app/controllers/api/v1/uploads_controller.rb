# frozen_string_literal: true

module Api
  module V1
    # return json
    class UploadsController < ApplicationController
      protect_from_forgery with: :exception
      before_action :authenticate_user!, except: %i[postcodes]
      skip_before_action :verify_authenticity_token, only: %i[postcodes]

      # :nocov:
      if Rails.env.production?
        http_basic_authenticate_with(
          name: ENV['SECRET_KEY_BASE'][42..52], # Marketplace.http_basic_auth_name,
          password: ENV['SECRET_KEY_BASE'][99..127] # Marketplace.http_basic_auth_password
        )
      end
      # :nocov:

      # usage:
      # curl --request POST --header "Content-Type: application/json" --data @aws-secrets-2.json http://localhost:3000/api/v1/postcode/upload
      def postcodes
        action = params[:slug]

        data = JSON.parse(request.body.read) unless request.body.read.size.zero?

        result = query(action, data)

        render json: { status: 200, result: result }
      rescue StandardError => e
        summary = {
          status: 500,
          error: e.to_s
        }
        render json: summary, status: :unprocessable_entity
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
