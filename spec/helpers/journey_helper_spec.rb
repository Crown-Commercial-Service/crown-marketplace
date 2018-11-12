require 'rails_helper'

RSpec.describe JourneyHelper, type: :helper do
  describe '#checked?' do
    let(:checked) { helper.checked?(actual, expected) }

    context 'when expected is yes' do
      let(:expected) { 'yes' }

      context 'and actual is also yes' do
        let(:actual) { 'yes' }

        it 'returns truthy' do
          expect(checked).to be_truthy
        end
      end

      context 'and actual is no' do
        let(:actual) { 'no' }

        it 'returns falsey' do
          expect(checked).to be_falsey
        end
      end

      context 'and actual is nil' do
        let(:actual) { nil }

        it 'returns falsey' do
          expect(checked).to be_falsey
        end
      end
    end

    context 'when expected is no' do
      let(:expected) { 'no' }

      context 'and actual is yes' do
        let(:actual) { 'yes' }

        it 'returns falsey' do
          expect(checked).to be_falsey
        end
      end

      context 'and actual is also no' do
        let(:actual) { 'no' }

        it 'returns truthy' do
          expect(checked).to be_truthy
        end
      end

      context 'and actual is nil' do
        let(:actual) { nil }

        it 'returns falsey' do
          expect(checked).to be_falsey
        end
      end
    end
  end
end
