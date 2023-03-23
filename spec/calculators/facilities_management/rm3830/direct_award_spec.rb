require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::DirectAward do
  describe '.calculate' do
    it 'will return eligible for parameters when service standard is A' do
      da = described_class.new('STANDARD', 'A', 'true', 100000)
      result = da.calculate
      expect(result).to be true
    end

    it 'will return eligible for parameters when service standard is nil' do
      service_standard = nil
      da = described_class.new('STANDARD', service_standard, 'true', 100000)
      result = da.calculate
      expect(result).to be true
    end

    it 'will return un-eligible for parameters when service standard is B' do
      da = described_class.new('STANDARD', 'B', 'true', 100000)
      result = da.calculate
      expect(result).to be false
    end

    it 'will return eligible for parameters when service standard is N/A' do
      da = described_class.new('STANDARD', 'N/A', 'true', 100000)
      result = da.calculate
      expect(result).to be true
    end

    it 'will return un-eligible for parameters when assessed value is greater than £1.5M' do
      da = described_class.new('STANDARD', 'A', 'true', 1500010)
      result = da.calculate
      expect(result).to be false
    end

    it 'will return un-eligible for parameters when building type is non standard' do
      da = described_class.new('NON-STANDARD', 'A', 'true', 1000000)
      result = da.calculate
      expect(result).to be false
    end

    it 'will return un-eligible for parameters when priced_at_framework is false' do
      da = described_class.new('STANDARD', 'A', 'false', 1000000)
      result = da.calculate
      expect(result).to be false
    end
  end
end
