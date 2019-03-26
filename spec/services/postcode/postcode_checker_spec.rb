# frozen_string_literal: true

require 'rails_helper'
require 'postcode/postcode_checker'

RSpec.describe Postcode::PostcodeChecker do
  describe 'POST postcode' do
    it 'Postcode not in London' do
      expect(described_class.in_london?('G32 0RP')).to be false
    end

    it 'Postcode in London' do
      expect(described_class.in_london?('SW1P 2BA')).to be true
    end

    it 'Bad postcode not in London' do
      expect(described_class.in_london?('X11 1XX')).to be false
    end

    it 'nuts code in Westminster' do
      place = described_class.location_info('SW1P 2BA')
      expect(place[:result]['nuts']).to eq 'Westminster'
    end

    it 'admin district is Westminster' do
      place = described_class.location_info('SW1P 2BA')
      expect(place[:result]['admin_district']).to eq 'Westminster'
    end
  end
end
