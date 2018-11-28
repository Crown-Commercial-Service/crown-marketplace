module Login
  UnknownProvider = Class.new(StandardError)

  def self.class_for_provider(provider)
    case provider.to_s
    when 'cognito'
      CognitoLogin
    when 'dfe'
      DfeLogin
    else
      raise UnknownProvider, "unknown provider #{provider.inspect}"
    end
  end

  def self.from_session(str)
    return nil if str.nil?

    hash = JSON.parse(str)
    class_for_provider(hash['auth_provider']).new(
      email: hash['email'],
      extra: hash['extra']
    )
  end

  def self.from_omniauth(hash)
    class_for_provider(hash['provider']).from_omniauth(hash)
  end
end
