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

    def auth_provider
      raise 'not implemented'
    end

    def logout_path(_routable)
      raise 'not implemented'
    end

    def permit?(_framework)
      raise 'not implemented'
    end
  end
end
