require 'rails_helper'

RSpec.describe FacilitiesManagement::Admin::RateValidator do
  subject(:result) { validator.valid?(required_validation) }

  let(:validator) { described_class.new(rate, allow_blank) }
  let(:allow_blank) { true }

  describe '.valid?' do
    context 'when the rate is nil' do
      let(:rate) { nil }

      context 'and the required_validation is nil' do
        let(:required_validation) { nil }

        it 'is valid' do
          expect(result).to be true
        end
      end

      context 'and the required_validation is nil and it is not allowed to be blank' do
        let(:required_validation) { nil }
        let(:allow_blank) { false }

        it 'is not valid' do
          expect(result).to be false
        end
      end

      context 'and the required_validation is full_range' do
        let(:required_validation) { :full_range }

        it 'is valid' do
          expect(result).to be true
        end
      end
    end

    context 'when the rate is blank' do
      let(:rate) { '' }

      context 'and the required_validation is nil' do
        let(:required_validation) { nil }

        it 'is valid' do
          expect(result).to be true
        end
      end

      context 'and the required_validation is nil and it is not allowed to be blank' do
        let(:required_validation) { nil }
        let(:allow_blank) { false }

        it 'is not valid' do
          expect(result).to be false
        end
      end

      context 'and the required_validation is full_range' do
        let(:required_validation) { :full_range }

        it 'is valid' do
          expect(result).to be true
        end
      end
    end

    context 'when the rate is a string' do
      let(:rate) { 'hello' }

      context 'and the required_validation is nil' do
        let(:required_validation) { nil }

        it 'is not valid and the error type is not_a_number' do
          expect(result).to be false
          expect(validator.error_type).to eq 'not_a_number'
        end
      end

      context 'and the required_validation is full_range' do
        let(:required_validation) { :full_range }

        it 'is not valid and the error type is not_a_number' do
          expect(result).to be false
          expect(validator.error_type).to eq 'not_a_number'
        end
      end
    end

    context 'when the rate is not number' do
      let(:rate) { '1 2 3 4' }

      context 'and the required_validation is nil' do
        let(:required_validation) { nil }

        it 'is not valid and the error type is not_a_number' do
          expect(result).to be false
          expect(validator.error_type).to eq 'not_a_number'
        end
      end

      context 'and the required_validation is full_range' do
        let(:required_validation) { :full_range }

        it 'is not valid and the error type is not_a_number' do
          expect(result).to be false
          expect(validator.error_type).to eq 'not_a_number'
        end
      end
    end

    context 'when the rate is a more than max decimals' do
      let(:rate) { '0.123456789012345678901' }

      context 'and the required_validation is nil' do
        let(:required_validation) { nil }

        it 'is valid' do
          expect(result).to be true
        end
      end

      context 'and the required_validation is full_range' do
        let(:required_validation) { :full_range }

        it 'is not valid and the error type is more_than_max_decimals' do
          expect(result).to be false
          expect(validator.error_type).to eq 'more_than_max_decimals'
        end
      end
    end

    context 'when the rate is more than 1' do
      let(:rate) { '1.0000001' }

      context 'and the required_validation is nil' do
        let(:required_validation) { nil }

        it 'is valid' do
          expect(result).to be true
        end
      end

      context 'and the required_validation is full_range' do
        let(:required_validation) { :full_range }

        it 'is not valid and the error type is less_than_or_equal_to' do
          expect(result).to be false
          expect(validator.error_type).to eq 'less_than_or_equal_to'
        end
      end
    end

    context 'when the rate is less than 0' do
      let(:rate) { '-0.01' }

      context 'and the required_validation is nil' do
        let(:required_validation) { nil }

        it 'is not valid and the error type is greater_than_or_equal_to' do
          expect(result).to be false
          expect(validator.error_type).to eq 'greater_than_or_equal_to'
        end
      end

      context 'and the required_validation is full_range' do
        let(:required_validation) { :full_range }

        it 'is not valid and the error type is greater_than_or_equal_to' do
          expect(result).to be false
          expect(validator.error_type).to eq 'greater_than_or_equal_to'
        end
      end
    end

    context 'when the rate is less than 1' do
      let(:rate) { '0.089' }

      context 'and the required_validation is nil' do
        let(:required_validation) { nil }

        it 'is valid' do
          expect(result).to be true
        end
      end

      context 'and the required_validation is full_range' do
        let(:required_validation) { :full_range }

        it 'is valid' do
          expect(result).to be true
        end
      end
    end

    context 'when the rate has 20 decimals' do
      let(:rate) { '0.12345678901234567890' }

      context 'and the required_validation is nil' do
        let(:required_validation) { nil }

        it 'is valid' do
          expect(result).to be true
        end
      end

      context 'and the required_validation is full_range' do
        let(:required_validation) { :full_range }

        it 'is valid' do
          expect(result).to be true
        end
      end
    end
  end
end
