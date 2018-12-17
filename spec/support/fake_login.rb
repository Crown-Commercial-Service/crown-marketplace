module SpecSupport
  module FakeLogin
    # rubocop:disable RSpec/AnyInstance
    def ensure_logged_in
      allow_any_instance_of(ApplicationController)
        .to receive(:current_login)
        .and_return(Login::CognitoLogin.new(email: 'user@example.com', extra: {}))
    end

    def ensure_not_logged_in
      allow_any_instance_of(ApplicationController)
        .to receive(:current_login)
        .and_return(nil)
    end

    def permit_framework(name)
      allow_any_instance_of(Login::CognitoLogin)
        .to receive(:permit?)
        .with(name)
        .and_return(true)
    end
    # rubocop:enable RSpec/AnyInstance
  end
end

RSpec.configure do |config|
  config.include SpecSupport::FakeLogin, type: :controller
  config.include SpecSupport::FakeLogin, type: :request

  config.before(:example, type: :controller, auth: true) do
    ensure_logged_in
  end

  config.before(:example, type: :request) do
    ensure_logged_in
  end
end
