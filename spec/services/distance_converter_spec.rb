require 'rails_helper'

RSpec.describe DistanceConverter do
  describe '.miles_to_metres' do
    it 'converts miles to metres' do
      expect(described_class.miles_to_metres(1)).to be(1609.34)
    end
  end

  describe '.metres_to_miles' do
    it 'converts metres to miles' do
      expect(described_class.metres_to_miles(1609.34)).to be(1.0)
    end
  end
end
