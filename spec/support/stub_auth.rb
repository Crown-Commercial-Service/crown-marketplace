module SpecSupport
  module StubAuth
    def stub_auth
      OmniAuth.config.test_mode = true

      OmniAuth.config.mock_auth[:cognito] = OmniAuth::AuthHash.new(
        provider: :cognito,
        info: { email: 'user@example.com' }
      )
      OmniAuth.config.mock_auth[:dfe] = OmniAuth::AuthHash.new(
        provider: :dfe,
        info: { email: 'user@example.com' }
      )
    end

    def unstub_auth
      OmniAuth.config.test_mode = false
    end
  end
end

RSpec.configure do |config|
  config.include SpecSupport::StubAuth, type: :feature

  config.around(:example, type: :feature) do |example|
    stub_auth
    example.run
    unstub_auth
  end
end
