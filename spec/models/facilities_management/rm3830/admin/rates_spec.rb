require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::Admin::Rates do
  subject(:rate) { described_class.new(code: rate_code) }

  let(:rate_code) { 'M.1' }

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
          expect(rate.errors[rate_field].first).to eq 'The rate must be a number, like 0.26 or 1'
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
          expect(rate.errors[rate_field].first).to eq 'The rate must be a number, like 0.26 or 1'
        end
      end

      context 'with absent leading digit input' do
        let(:rate_value) { '.2' }

        it 'valid' do
          expect(rate).to be_valid(rate_field)
        end
      end

      context 'when the rate type is percentage with a value greater than 1' do
        let(:rate_value) { '1.0001' }

        before { rate.code = 'N.1' }

        it 'not valid' do
          expect(rate).not_to be_valid(rate_field)
        end

        it 'has the correct error message' do
          rate.valid? rate_field
          expect(rate.errors[rate_field].first).to eq 'The rate must be less than or equal to 1'
        end
      end
    end
  end

  describe 'range_validation_required?' do
    context 'when the rate uses percentage' do
      %w[M.1 N.1 M.140 M.141 M.142 M.144 M.148 B.1].each do |code|
        let(:rate_code) { code }

        it "returns true for #{code}" do
          expect(rate.send(:range_validation_required?)).to be true
        end

        context 'and there is an error' do
          before { rate.errors.add(:base, :new_error) }

          it "returns false for #{code}" do
            expect(rate.send(:range_validation_required?)).to be false
          end
        end
      end
    end

    context 'when the rate does not use percentage' do
      let(:rate_code) { 'C.1' }

      it 'returns false' do
        expect(rate.send(:range_validation_required?)).to be false
      end
    end
  end
end
