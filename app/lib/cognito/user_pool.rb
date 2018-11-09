module Cognito
  class UserPool
    attr_reader :app_client_id

    def initialize(region, pool_id, app_client_id)
      @region = region
      @pool_id = pool_id
      @app_client_id = app_client_id
    end

    def find_key(key_id)
      json_web_keys.find { |jwk| jwk['kid'] == key_id }.to_key
    end

    def json_web_keys
      response = Faraday.get(keys_url)
      JSON::JWK::Set.new(JSON.parse(response.body))
    end

    def keys_url
      "#{idp_url}/.well-known/jwks.json"
    end

    def idp_url
      "https://cognito-idp.#{@region}.amazonaws.com/#{@pool_id}"
    end
  end
end
