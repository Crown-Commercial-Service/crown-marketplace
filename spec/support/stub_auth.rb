module SpecSupport
  module StubAuth
    def stub_auth
      OmniAuth.config.test_mode = true

      OmniAuth.config.mock_auth[:cognito] = OmniAuth::AuthHash.new(
        'provider' => 'cognito',
        'info' => { 'email' => 'cognito@example.com' }
      )
      OmniAuth.config.mock_auth[:dfe] = OmniAuth::AuthHash.new(
        'provider' => 'dfe',
        'info' => { 'email' => 'dfe@example.com' },
        'extra' => {
          'raw_info' => {
            'organisation' => {
              'id' => '047F32E7-FDD5-46E9-89D4-2498C2E77364',
              'name' => 'St Custard’s',
              'urn' => '900002',
              'ukprn' => '90000002',
              'category' => {
                'id' => '001',
                'name' => 'Establishment'
              },
              'type' => {
                'id' => '01',
                'name' => 'Community school'
              }
            }
          }
        }
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
