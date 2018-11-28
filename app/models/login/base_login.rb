module Login
  class BaseLogin
    attr_reader :email

    def initialize(email:, extra:)
      @email = email
      @extra = extra
    end

    def to_session
      JSON.generate(
        'auth_provider' => auth_provider,
        'email' => email,
        'extra' => @extra
      )
    end
  end
end
