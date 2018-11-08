require 'omniauth-oauth2'
require 'jwt'

module OmniAuth
  module Strategies
    class Cognito < OmniAuth::Strategies::OAuth2
      option :name, 'cognito'
      option :client_options,
             authorize_url: '/oauth2/authorize',
             token_url: '/oauth2/token',
             auth_scheme: :basic_auth,
             region: nil,
             user_pool_id: nil

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

        @validated_id_token ||= begin
          user_pool = ::Cognito::UserPool.new(options.region, options.user_pool_id)
          token = ::Cognito::EncodedToken.new(id_token)
          token.decode(user_pool)
        end
      end
    end
  end
end
