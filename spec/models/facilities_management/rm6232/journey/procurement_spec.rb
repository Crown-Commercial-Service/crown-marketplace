require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6232::Journey::Procurement, type: :model do
  let(:procurement) { described_class.new }

  describe '.next_step_class' do
    it 'returns nil' do
      expect(procurement.next_step_class).to be_nil
    end
  end

  describe '.permit_list' do
    it 'returns an empty list' do
      expect(described_class.permit_list).to eq [{}]
    end
  end

  describe '.permitted_keys' do
    it 'returns an empty list' do
      expect(described_class.permitted_keys).to eq []
    end
  end

  describe '.slug' do
    it 'returns contract-cost' do
      expect(procurement.slug).to eq 'procurement'
    end
  end

  describe '.template' do
    it 'returns journey/procurement' do
      expect(procurement.template).to eq 'journey/procurement'
    end
  end

  describe '.final?' do
    it 'returns true' do
      expect(procurement.final?).to be true
    end
  end
end
