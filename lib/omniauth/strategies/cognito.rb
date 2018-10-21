require 'omniauth-oauth2'
require 'jwt'

module OmniAuth
  module Strategies
    class Cognito < OmniAuth::Strategies::OAuth2
      option :name, 'cognito'
      option :client_options,
             authorize_url: '/oauth2/authorize',
             token_url: '/oauth2/token',
             auth_scheme: :basic_auth
      option :user_pool_id, nil
      option :aws_region, nil

      uid do
        validated_id_token['sub'] if validated_id_token
      end

      info do
        if validated_id_token
          {
            email: validated_id_token['email'],
          }
        end
      end

      def callback_url
        full_host + script_name + callback_path
      end

      private

      def issuer
        "https://cognito-idp.#{options[:aws_region]}.amazonaws.com/#{options[:user_pool_id]}"
      end

      def audience
        options[:client_id]
      end

      def id_token
        access_token['id_token']
      end

      def validated_id_token
        return nil unless id_token

        @validated_id_token ||= JWT.decode(
          id_token,
          nil,
          false,
          verify_iss: true,
          iss: issuer,
          verify_aud: true,
          aud: audience,
          verify_sub: true,
          verify_expiration: true,
          verify_not_before: true,
          verify_iat: true,
          verify_jti: false,
          leeway: 60
        ).first
      end
    end
  end
end
