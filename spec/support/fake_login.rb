module SpecSupport
  module FakeLogin
    # rubocop:disable RSpec/AnyInstance
    def ensure_logged_in
      allow_any_instance_of(ApplicationController)
        .to receive(:logged_in?)
        .and_return(true)
    end

    def ensure_not_logged_in
      allow_any_instance_of(ApplicationController)
        .to receive(:logged_in?)
        .and_return(false)
    end

    def permit_framework(name)
      allow_any_instance_of(ApplicationController)
        .to receive(:require_framework_permission)
        .with(name)
        .and_return(true)
    end
    # rubocop:enable RSpec/AnyInstance
  end
end

RSpec.configure do |config|
  config.include SpecSupport::FakeLogin, type: :controller
  config.include SpecSupport::FakeLogin, type: :request

  config.before(:example, type: :controller) do
    ensure_logged_in
  end

  config.before(:example, type: :request) do
    ensure_logged_in
  end
end
