require 'rails_helper'
require 'fm_calculator/fm_direct_award_calculator.rb'
RSpec.describe DirectAward do
  describe '.calculate' do
    it 'will return eligible for parameters when service standard is A' do
      da = described_class.new('STANDARD', 'A', 'true', 100000)
      result = da.calculate
      expect(result).to eq true
    end
  end

  describe '.calculate' do
    it 'will return eligible for parameters when service standard is nil' do
      service_standard = nil
      da = described_class.new('STANDARD', service_standard, 'true', 100000)
      result = da.calculate
      expect(result).to eq true
    end
  end

  describe '.calculate' do
    it 'will return un-eligible for parameters when service standard is B' do
      da = described_class.new('STANDARD', 'B', 'true', 100000)
      result = da.calculate
      expect(result).to eq false
    end
  end

  describe '.calculate' do
    it 'will return un-eligible for parameters when assessed value is greater than £1.5M' do
      da = described_class.new('STANDARD', 'A', 'true', 1500010)
      result = da.calculate
      expect(result).to eq false
    end
  end

  describe '.calculate' do
    it 'will return un-eligible for parameters when building type is non standard' do
      da = described_class.new('NON-STANDARD', 'A', 'true', 1000000)
      result = da.calculate
      expect(result).to eq false
    end
  end

  describe '.calculate' do
    it 'will return un-eligible for parameters when priced_at_framework is false' do
      da = described_class.new('STANDARD', 'A', 'false', 1000000)
      result = da.calculate
      expect(result).to eq false
    end
  end
end
