require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6232::Journey::StartASearch, type: :model do
  let(:start_a_search) { described_class.new }

  describe 'validations' do
    it 'is valid' do
      expect(start_a_search.valid?).to be true
    end
  end

  describe '.next_step_class' do
    it 'returns Journey::ChooseServices' do
      expect(start_a_search.next_step_class).to be FacilitiesManagement::RM6232::Journey::ChooseServices
    end
  end

  describe '.permit_list' do
    it 'returns a list of the permitted attributes' do
      expect(described_class.permit_list).to eq [:annual_contract_value, { service_codes: [], region_codes: [] }]
    end
  end

  describe '.permitted_keys' do
    it 'returns a list of the permitted keys' do
      expect(described_class.permitted_keys).to eq %i[service_codes region_codes annual_contract_value]
    end
  end

  describe '.slug' do
    it 'returns start-a-search' do
      expect(start_a_search.slug).to eq 'start-a-search'
    end
  end

  describe '.template' do
    it 'returns journey/start_a_search' do
      expect(start_a_search.template).to eq 'journey/start_a_search'
    end
  end

  describe '.final?' do
    it 'returns false' do
      expect(start_a_search.final?).to be false
    end
  end
end
