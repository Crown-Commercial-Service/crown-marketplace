require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6232::Journey::StartAProcurement, type: :model do
  let(:start_a_procurement) { described_class.new }

  describe 'validations' do
    it 'is valid' do
      expect(start_a_procurement.valid?).to be true
    end
  end

  describe '.next_step_class' do
    it 'returns Journey::ChooseServices' do
      expect(start_a_procurement.next_step_class).to be FacilitiesManagement::RM6232::Journey::ChooseServices
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
    it 'returns start-a-procurement' do
      expect(start_a_procurement.slug).to eq 'start-a-procurement'
    end
  end

  describe '.template' do
    it 'returns journey/start_a_procurement' do
      expect(start_a_procurement.template).to eq 'journey/start_a_procurement'
    end
  end

  describe '.final?' do
    it 'returns false' do
      expect(start_a_procurement.final?).to be false
    end
  end
end
