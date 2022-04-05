require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6232::Service, type: :model do
  describe '.work_package' do
    let(:result) { described_class.find(code).work_package.code }

    context 'when the code is A.10' do
      let(:code) { 'A.10' }

      it 'has the right work package A' do
        expect(result).to eq 'A'
      end
    end

    context 'when the code is E.21' do
      let(:code) { 'E.21' }

      it 'has the right work package E' do
        expect(result).to eq 'E'
      end
    end

    context 'when the code is J.14' do
      let(:code) { 'J.14' }

      it 'has the right work package J' do
        expect(result).to eq 'J'
      end
    end

    context 'when the code is M.3' do
      let(:code) { 'M.3' }

      it 'has the right work package M' do
        expect(result).to eq 'M'
      end
    end

    context 'when the code is Q.1' do
      let(:code) { 'Q.1' }

      it 'has the right work package Q' do
        expect(result).to eq 'Q'
      end
    end
  end
end
