require 'rails_helper'

RSpec.describe StaticDataLoader do
  describe '.nuts1_codes_not_empty' do
    it 'there is at least one Nuts1 Region' do
      described_class.load_static_data(Nuts1Region)
      expect(Nuts1Region.none?).to be(false)
    end
  end

  describe '.nuts2_codes_not_empty' do
    it 'there is at least 1 Nuts2 Regions' do
      described_class.load_static_data(Nuts2Region)
      expect(Nuts2Region.none?).to be(false)
    end
  end

  describe '.nuts3_codes_not_empty' do
    it 'there is at least 1 Nuts3 Region' do
      described_class.load_static_data(Nuts3Region)
      expect(Nuts3Region.none?).to be(false)
    end
  end
end
