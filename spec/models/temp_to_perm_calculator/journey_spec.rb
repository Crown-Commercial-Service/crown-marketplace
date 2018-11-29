require 'rails_helper'

RSpec.describe TempToPermCalculator::Journey, type: :model do
  it 'has a journey name' do
    expect(described_class.journey_name).to eq('temp-to-perm-calculator')
  end

  it 'has a first step class' do
    expect(described_class.first_step_class).to eq(TempToPermCalculator::Journey::ContractStart)
  end

  context 'when on the contract-start page' do
    subject(:journey) do
      TempToPermCalculator::Journey.new(slug, ActionController::Parameters.new(params))
    end

    let(:slug) { 'contract-start' }
    let(:params) { {} }

    it { is_expected.to have_attributes(current_slug: slug) }
    it { is_expected.to have_attributes(previous_slug: nil) }
    it { is_expected.to have_attributes(next_slug: 'fee') }
    it { is_expected.to have_attributes(params: {}) }
    it { is_expected.to have_attributes(template: 'temp_to_perm_calculator/journey/contract_start') }
  end
end
