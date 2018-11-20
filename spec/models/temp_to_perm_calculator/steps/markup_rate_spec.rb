require 'rails_helper'

RSpec.describe TempToPermCalculator::Steps::MarkupRate, type: :model do
  subject(:step) do
    described_class.new(
      markup_rate: markup_rate
    )
  end

  let(:markup_rate) { 40 }

  it { is_expected.to be_valid }

  describe '#next_step_class' do
    it 'is Fee' do
      expect(step.next_step_class).to eq(TempToPermCalculator::Steps::Fee)
    end
  end

  context 'with a missing markup_rate' do
    let(:markup_rate) { nil }

    it { is_expected.to be_invalid }
  end

  context 'with a non-numeric markup_rate' do
    let(:markup_rate) { 'abc' }

    it { is_expected.to be_invalid }
  end

  context 'with a markup_rate greater than 100' do
    let(:markup_rate) { 110 }

    it { is_expected.to be_invalid }
  end

  context 'with a markup_rate less than 0' do
    let(:markup_rate) { -10 }

    it { is_expected.to be_invalid }
  end
end
