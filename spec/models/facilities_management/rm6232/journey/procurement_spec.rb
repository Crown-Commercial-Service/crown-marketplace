require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6232::Journey::Procurement do
  let(:procurement) { described_class.new }

  describe '.next_step_class' do
    it 'returns nil' do
      expect(procurement.next_step_class).to be_nil
    end
  end

  describe '.final?' do
    it 'returns true' do
      expect(procurement.final?).to be true
    end
  end
end
