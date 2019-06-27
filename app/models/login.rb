module Login
  UnknownProvider = Class.new(StandardError)

  EMAIL_REGEX = /([\w+\-.]+)@([a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+)/i.freeze

  def self.class_for_provider(provider)
    case provider.to_s
    when 'dfe'
      DfeLogin
    else
      raise UnknownProvider, "unknown provider #{provider.inspect}"
    end
  end

  def self.from_omniauth(hash)
    class_for_provider(hash['provider']).from_omniauth(hash)
  end

  def self.redact_email(string)
    matched = EMAIL_REGEX.match(string)
    redacted_string = '_' * (matched[1].length - 1)
    redacted_email = "#{matched[1][0]}#{redacted_string}@#{matched[2]}"
    string.gsub(EMAIL_REGEX, redacted_email)
  end
end
