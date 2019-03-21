# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PostcodeChecker do
  describe 'POST postcode' do
    it 'Postcode not in London' do
      expect(PostcodeChecker.inLondon?('G32 0RP')).to be false
    end

    it 'Postcode in London' do
      expect(PostcodeChecker.inLondon?('SW1P 2BA')).to be true
    end

    it 'Bad postcode not in London' do
      expect(PostcodeChecker.inLondon?('X11 1XX')).to be false
    end

    it 'nuts code in Westminster' do
      place = PostcodeChecker.location_info('SW1P 2BA')
      expect(place['nuts']).to eq 'Westminster'
    end

    it 'admin district is Westminster' do
      place = PostcodeChecker.location_info('SW1P 2BA')
      expect(place['admin_district']).to eq 'Westminster'
    end
  end
end
