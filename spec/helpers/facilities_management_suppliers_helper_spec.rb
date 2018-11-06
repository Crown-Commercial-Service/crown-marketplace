require 'rails_helper'

RSpec.describe FacilitiesManagementSuppliersHelper, type: :helper do
  describe '#contract_value_range_text' do
    let(:text) { helper.contract_value_range_text(lot_number) }

    context 'when lot_number is 1a' do
      let(:lot_number) { '1a' }

      it 'returns contract value range text for the lot number' do
        expect(text).to eq('Total contract value up to £7M')
      end
    end

    context 'when lot_number is 1b' do
      let(:lot_number) { '1b' }

      it 'returns contract value range text for the lot number' do
        expect(text).to eq('Total contract value £7M - £50M')
      end
    end

    context 'when lot_number is 1c' do
      let(:lot_number) { '1c' }

      it 'returns contract value range text for the lot number' do
        expect(text).to eq('Total contract value over £50M')
      end
    end
  end

  describe '#grouped_by_mandatory' do
    let(:mandatory_service1) { FacilitiesManagement::Service.new(mandatory: 'true') }
    let(:mandatory_service2) { FacilitiesManagement::Service.new(mandatory: 'true') }

    let(:non_mandatory_service1) { FacilitiesManagement::Service.new(mandatory: 'false') }
    let(:non_mandatory_service2) { FacilitiesManagement::Service.new(mandatory: 'false') }

    let(:services) do
      [
        mandatory_service1,
        non_mandatory_service1,
        mandatory_service2,
        non_mandatory_service2
      ]
    end

    let(:result) { helper.grouped_by_mandatory(services) }

    it 'groups mandatory services together' do
      expect(Hash[result][true]).to contain_exactly(
        mandatory_service1, mandatory_service2
      )
    end

    it 'groups non-mandatory services together' do
      expect(Hash[result][false]).to contain_exactly(
        non_mandatory_service1, non_mandatory_service2
      )
    end

    it 'orders mandatory services before non-mandatory services' do
      expect(result.map(&:first)).to eq([true, false])
    end
  end

  describe '#service_type' do
    it 'returns "Basic services" when mandatory' do
      expect(helper.service_type(true)).to eq('Basic services')
    end

    it 'returns "Extra services" when not mandatory' do
      expect(helper.service_type(false)).to eq('Extra services')
    end
  end
end
