require 'rails_helper'

RSpec.describe FacilitiesManagement::ProcurementsHelper, type: :helper do
  describe '.section_id' do
    let(:result) { helper.section_id(section) }

    context 'when the section is contract_name' do
      let(:section) { 'contract_name' }

      it 'returns contract_name-tag' do
        expect(result).to eq 'contract_name-tag'
      end
    end

    context 'when the section is estimated_annual_cost' do
      let(:section) { 'estimated_annual_cost' }

      it 'returns estimated_annual_cost-tag' do
        expect(result).to eq 'estimated_annual_cost-tag'
      end
    end

    context 'when the section is tupe' do
      let(:section) { 'tupe' }

      it 'returns tupe-tag' do
        expect(result).to eq 'tupe-tag'
      end
    end

    context 'when the section is contract_period' do
      let(:section) { 'contract_period' }

      it 'returns contract_period-tag' do
        expect(result).to eq 'contract_period-tag'
      end
    end

    context 'when the section is services' do
      let(:section) { 'services' }

      it 'returns services-tag' do
        expect(result).to eq 'services-tag'
      end
    end

    context 'when the section is buildings' do
      let(:section) { 'buildings' }

      it 'returns buildings-tag' do
        expect(result).to eq 'buildings-tag'
      end
    end

    context 'when the section is buildings_and_services' do
      let(:section) { 'buildings_and_services' }

      it 'returns buildings_and_services-tag' do
        expect(result).to eq 'buildings_and_services-tag'
      end
    end

    context 'when the section is service_requirements' do
      let(:section) { 'service_requirements' }

      it 'returns service_requirements-tag' do
        expect(result).to eq 'service_requirements-tag'
      end
    end
  end

  describe '.section_errors' do
    let(:result) { helper.section_errors(section) }

    context 'when the section is contrct period' do
      let(:section) { 'contract_period' }

      it 'returns an array of the possible contract period errors' do
        expect(result).to eq %i[contract_period_incomplete initial_call_off_period_in_past mobilisation_period_in_past mobilisation_period_required]
      end
    end

    context 'when the section is not contract period' do
      let(:section) { 'buildings' }

      it 'returns an array of the section incomplete' do
        expect(result).to eq %i[buildings_incomplete]
      end
    end
  end
end
