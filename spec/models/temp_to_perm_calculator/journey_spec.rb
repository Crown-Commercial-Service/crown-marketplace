require 'rails_helper'
require 'temp_to_perm_calculator/journey'

module TempToPermCalculator
  RSpec.describe Journey, type: :model do
    it 'has a journey name' do
      expect(described_class.journey_name).to eq('temp-to-perm-calculator')
    end

    it 'has a first step class' do
      expect(described_class.first_step_class).to eq(Steps::ContractStart)
    end

    context 'when on the contract-start page' do
      subject(:journey) do
        Journey.new(slug, ActionController::Parameters.new(params))
      end

      let(:slug) { 'contract-start' }
      let(:params) { {} }

      it { is_expected.to have_attributes(current_slug: slug) }
      it { is_expected.to have_attributes(previous_slug: nil) }
      it { is_expected.to have_attributes(next_slug: 'hire-date') }
      it { is_expected.to have_attributes(params: {}) }
      it { is_expected.to have_attributes(template: 'contract_start') }
    end
  end
end
