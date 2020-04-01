require 'rails_helper'

RSpec.describe FacilitiesManagement::Admin::Rates, type: :model do
  subject(:rate) { described_class.new }

  %i[benchmark framework].each do |rate_field|
    describe rate_field.to_s do
      context 'with numeric input having decimal places' do
        it 'valid' do
          rate.send(:"#{rate_field}=", 0.5)
          expect(rate).to be_valid
        end
      end

      context 'with numeric input having no decimal places' do
        it 'not valid' do
          rate.send(:"#{rate_field}=", 1)
          expect(rate).not_to be_valid
        end
      end

      context 'with non-numeric input' do
        it 'not valid' do
          rate.send(:"#{rate_field}=", 'underpants')
          expect(rate).not_to be_valid
        end
      end

      context 'with nil input' do
        it 'valid' do
          rate.send(:"#{rate_field}=", nil)
          expect(rate).to be_valid
        end
      end

      context 'with multiple periods input' do
        it 'not valid' do
          rate.send(:"#{rate_field}=", '1.2.3')
          expect(rate).not_to be_valid
        end
      end

      context 'with absent leading digit input' do
        it 'valid' do
          rate.send(:"#{rate_field}=", '.2')
          expect(rate).to be_valid
        end
      end
    end
  end
end
