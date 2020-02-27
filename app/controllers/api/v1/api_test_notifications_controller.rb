# frozen_string_literal: true

module Api
  module V1
    # return json
    class ApiTestNotificationsController < ApplicationController
      before_action :authenticate_user!, only: [:notification_callback]
      # skip_before_action :verify_authenticity_token, if: Proc { |c| c.request.format == 'application/json' }

      def send_notification
        template_name = params['template-name']
        email_to = params['email-to']
        gov_notify_arg = params

        Rails.logger.info params
        Rails.logger.info template_name
        if ENV['TEST_EMAIL_TEMPLATES_API_TOKEN'] == request.headers['Authorization'].split(' ').last
          notification = FacilitiesManagement::GovNotifyNotification.send_email_notification(template_name, email_to, gov_notify_arg)
          render json: { status: 200, result: notification }
        else
          render json: { status: 404, result: 'You need a token to access this end point' }
        end
      rescue StandardError => e
        render json: { status: 404, error: e.to_s }
      end

      def notification_callback
        Rails.logger.info params[:name]
      rescue StandardError => e
        render json: { status: 404, error: e.to_s }
      end
    end
  end
end
