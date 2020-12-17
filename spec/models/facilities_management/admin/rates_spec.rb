require 'rails_helper'

RSpec.describe FacilitiesManagement::Admin::Rates, type: :model do
  subject(:rate) { described_class.new }

  %i[benchmark framework].each do |rate_field|
    describe rate_field.to_s do
      before { rate.send(:"#{rate_field}=", rate_value) }

      context 'with numeric input having decimal places' do
        let(:rate_value) { 0.5 }

        it 'valid' do
          expect(rate).to be_valid(rate_field)
        end
      end

      context 'with numeric input having no decimal places' do
        let(:rate_value) { 1 }

        it 'valid' do
          expect(rate).to be_valid(rate_field)
        end
      end

      context 'with non-numeric input' do
        let(:rate_value) { 'underpants' }

        it 'not valid' do
          expect(rate).not_to be_valid(rate_field)
        end

        it 'has the correct error message' do
          rate.valid? rate_field
          expect(rate.errors[rate_field].first).to eq 'The rate must be a number, like 2.60 or 8'
        end
      end

      context 'with nil input' do
        let(:rate_value) { nil }

        it 'valid' do
          expect(rate).to be_valid(rate_field)
        end
      end

      context 'with multiple periods input' do
        let(:rate_value) { '1.2.3' }

        it 'not valid' do
          expect(rate).not_to be_valid(rate_field)
        end

        it 'has the correct error message' do
          rate.valid? rate_field
          expect(rate.errors[rate_field].first).to eq 'The rate must be a number, like 2.60 or 8'
        end
      end

      context 'with absent leading digit input' do
        let(:rate_value) { '.2' }

        it 'valid' do
          expect(rate).to be_valid(rate_field)
        end
      end
    end
  end
end
