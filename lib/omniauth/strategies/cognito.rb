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

      def jwk_url
        "https://cognito-idp.#{options.region}.amazonaws.com/#{options.user_pool_id}/.well-known/jwks.json"
      end

      def jwks
        response = Faraday.get(jwk_url)
        JSON::JWK::Set.new(JSON.parse(response.body))
      end

      def id_token
        access_token['id_token']
      end

      def validated_id_token
        return nil unless id_token

        @validated_id_token ||= begin
          decoder = TokenDecoder.new(id_token)
          key_id = decoder.unverified_header['kid']
          decoder.decode(jwks, key_id)
        end
      end

      class TokenDecoder
        def initialize(token)
          @token = token
        end

        def unverified_header
          JSON::JWT.decode(@token, :skip_verification).header
        end

        def decode(jwks, key_id)
          jwk = jwks.find { |jwk_attrs| jwk_attrs['kid'] == key_id }
          JSON::JWT.decode(@token, jwk.to_key)
        end
      end
    end
  end
end
