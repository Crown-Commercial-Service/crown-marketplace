module SpecSupport
  module FakePostcode
    def valid_fake_postcode
      possibly_invalid_postcode = Faker::Address.unique.postcode
      UKPostcode.parse(possibly_invalid_postcode).to_s
    end
  end
end

RSpec.configure do |config|
  config.include SpecSupport::FakePostcode
end
