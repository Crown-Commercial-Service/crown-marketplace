require 'rails_helper'

RSpec.describe FacilitiesManagement::ProcurementsHelper do
  include ApplicationHelper

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

  describe '.display_all_errors' do
    let(:section_errors) { %i[contract_period_incomplete initial_call_off_period_in_past mobilisation_period_in_past mobilisation_period_required] }
    let(:result) { display_all_errors(requirements_errors_list, section_errors) }

    context 'when there is one error' do
      let(:requirements_errors_list) { { contract_period_incomplete: '‘Contract period’ must be ‘COMPLETED’' } }

      it 'returns the single error' do
        expect(result).to eq('<span id="contract_period_incomplete-error" class="govuk-error-message">‘Contract period’ must be ‘COMPLETED’</span>')
      end
    end

    context 'when there are multiple errrors' do
      let(:requirements_errors_list) do
        {
          initial_call_off_period_in_past: 'Initial call-off period start date must not be in the past',
          mobilisation_period_in_past: 'Mobilisation period start date must not be in the past',
          mobilisation_period_required: 'Mobilisation period length must be a minimum of 4 weeks when TUPE is selected'
        }
      end

      it 'returns all the errors' do
        expect(result).to eq([
          '<span id="initial_call_off_period_in_past-error" class="govuk-error-message">Initial call-off period start date must not be in the past</span>',
          '<span id="mobilisation_period_in_past-error" class="govuk-error-message">Mobilisation period start date must not be in the past</span>',
          '<span id="mobilisation_period_required-error" class="govuk-error-message">Mobilisation period length must be a minimum of 4 weeks when TUPE is selected</span>'
        ].join)
      end
    end
  end
end
