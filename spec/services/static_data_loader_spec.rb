require "rails_helper"
# require Rails.root.to_s + '/app/models/facilities_management/region.rb'

RSpec.describe StaticDataLoader do

  describe '.regions_not_empty' do
    it 'there is at least one Region' do
      StaticDataLoader.load_static_data(FacilitiesManagement::Region)
      expect(FacilitiesManagement::Region.all.count.zero?).to be(false)
    end
  end

  describe '.nuts1_codes_not_empty' do
    it 'there is at least one Nuts1 Region' do
      StaticDataLoader.load_static_data(Nuts1Region)
      expect(Nuts1Region.all.count.zero?).to be(false)
    end
  end

  describe '.nuts2_codes_not_empty' do
    it 'there is at least 1 Nuts2 Regions' do
      StaticDataLoader.load_static_data(Nuts2Region)
      expect(Nuts2Region.all.count.zero?).to be(false)
    end
  end

  describe '.nuts3_codes_not_empty' do
    it 'there is at least 1 Nuts3 Region' do
      StaticDataLoader.load_static_data(Nuts3Region)
      expect(Nuts3Region.all.count.zero?).to be(false)
    end
  end
end
