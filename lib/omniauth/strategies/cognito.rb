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

      def id_token
        access_token['id_token']
      end

      def validated_id_token
        return nil unless id_token

        @validated_id_token ||= TokenDecoder.new(id_token).decode
      end

      class TokenDecoder
        def initialize(token)
          @token = token
        end

        def decode
          JSON::JWT.decode(@token, :skip_verification)
        end
      end
    end
  end
end
