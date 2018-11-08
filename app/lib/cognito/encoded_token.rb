module Cognito
  class EncodedToken
    def initialize(encoded_token)
      @encoded_token = encoded_token
    end

    def key_id
      JSON::JWT.decode(@encoded_token, :skip_verification).header['kid']
    end

    def decode(user_pool)
      key = user_pool.find_key(key_id)
      decoded_token = JSON::JWT.decode(@encoded_token, key)
      Token.new(decoded_token)
    end
  end
end
