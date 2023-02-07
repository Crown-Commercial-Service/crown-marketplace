require 'rails_helper'

RSpec.describe FacilitiesManagement::Framework do
  describe '.frameworks' do
    it 'returns RM3830 ad RM6232' do
      expect(described_class.frameworks).to eq ['RM3830', 'RM6232']
    end
  end

  shared_context 'and RM6232 is live in the future' do
    before { described_class.find_by(framework: 'RM6232').update(live_at: 1.day.from_now) }
  end

  shared_context 'and RM6232 is live today' do
    before { described_class.find_by(framework: 'RM6232').update(live_at: Time.zone.now) }
  end

  describe '.live_frameworks' do
    context 'when RM6232 goes live tomorrow' do
      include_context 'and RM6232 is live in the future'

      it 'returns only RM3830' do
        expect(described_class.live_frameworks).to eq ['RM3830']
      end
    end

    context 'when RM6232 is live today' do
      include_context 'and RM6232 is live today'

      it 'returns RM3830 and RM6232' do
        expect(described_class.live_frameworks).to eq ['RM3830', 'RM6232']
      end
    end

    context 'when RM6232 went live yesterday' do
      it 'returns RM3830 and RM6232' do
        expect(described_class.live_frameworks).to eq ['RM3830', 'RM6232']
      end
    end
  end

  describe '.default_framework' do
    context 'when RM6232 goes live tomorrow' do
      include_context 'and RM6232 is live in the future'

      it 'returns RM3830' do
        expect(described_class.default_framework).to eq 'RM3830'
      end
    end

    context 'when RM6232 is live today' do
      include_context 'and RM6232 is live today'

      it 'returns RM6232' do
        expect(described_class.default_framework).to eq 'RM6232'
      end
    end

    context 'when RM6232 went live yesterday' do
      it 'returns RM6232' do
        expect(described_class.default_framework).to eq 'RM6232'
      end
    end
  end

  describe '.recognised_live_framework' do
    context 'when the framework is RM3830' do
      it 'returns true' do
        expect(described_class.recognised_live_framework?('RM3830')).to be true
      end
    end

    context 'when the framework is RM6232' do
      context 'and RM6232 goes live tomorrow' do
        include_context 'and RM6232 is live in the future'

        it 'returns false' do
          expect(described_class.recognised_live_framework?('RM6232')).to be false
        end
      end

      context 'when RM6232 is live today' do
        include_context 'and RM6232 is live today'

        it 'returns true' do
          expect(described_class.recognised_live_framework?('RM6232')).to be true
        end
      end

      context 'and RM6232 went live yesterday' do
        it 'returns true' do
          expect(described_class.recognised_live_framework?('RM6232')).to be true
        end
      end
    end

    context 'when the framework is neither RM3830 ir RM6232' do
      it 'returns false' do
        expect(described_class.recognised_live_framework?('RM0087')).to be false
      end
    end
  end

  describe '.recognised_framework' do
    context 'when the framework is RM3830' do
      it 'returns true' do
        expect(described_class.recognised_framework?('RM3830')).to be true
      end
    end

    context 'when the framework is RM6232' do
      context 'and RM6232 goes live tomorrow' do
        include_context 'and RM6232 is live in the future'

        it 'returns true' do
          expect(described_class.recognised_framework?('RM6232')).to be true
        end
      end

      context 'when RM6232 is live today' do
        include_context 'and RM6232 is live today'

        it 'returns true' do
          expect(described_class.recognised_framework?('RM6232')).to be true
        end
      end

      context 'and RM6232 went live yesterday' do
        it 'returns true' do
          expect(described_class.recognised_framework?('RM6232')).to be true
        end
      end
    end

    context 'when the framework is neither RM3830 ir RM6232' do
      it 'returns false' do
        expect(described_class.recognised_framework?('RM0087')).to be false
      end
    end
  end

  describe '.status' do
    let(:framework) { create(:facilities_management_framework, live_at: live_at) }

    context 'when the live_at date is before today' do
      let(:live_at) { 1.day.ago }

      it 'returns live' do
        expect(framework.status).to eq :live
      end
    end

    context 'when the live_at date is today' do
      let(:live_at) { Time.zone.now }

      it 'returns live' do
        expect(framework.status).to eq :live
      end
    end

    context 'when the live_at date is after today' do
      let(:live_at) { 1.day.from_now }

      it 'returns coming' do
        expect(framework.status).to eq :coming
      end
    end
  end

  describe 'validating the live at date' do
    let(:framework) { create(:facilities_management_framework) }
    let(:live_at) { 1.day.from_now }
    let(:live_at_yyyy) { live_at.year.to_s }
    let(:live_at_mm) { live_at.month.to_s }
    let(:live_at_dd) { live_at.day.to_s }

    before do
      framework.live_at_yyyy = live_at_yyyy
      framework.live_at_mm = live_at_mm
      framework.live_at_dd = live_at_dd
    end

    context 'when considering live_at_yyyy and it is nil' do
      let(:live_at_yyyy) { nil }

      it 'is not valid and has the correct error message' do
        expect(framework.valid?(:update)).to be false
        expect(framework.errors[:live_at].first).to eq 'Enter a valid \'live at\' date'
      end
    end

    context 'when considering live_at_mm and it is blank' do
      let(:live_at_mm) { '' }

      it 'is not valid and has the correct error message' do
        expect(framework.valid?(:update)).to be false
        expect(framework.errors[:live_at].first).to eq 'Enter a valid \'live at\' date'
      end
    end

    context 'when considering live_at_dd and it is empty' do
      let(:live_at_dd) { '    ' }

      it 'is not valid and has the correct error message' do
        expect(framework.valid?(:update)).to be false
        expect(framework.errors[:live_at].first).to eq 'Enter a valid \'live at\' date'
      end
    end

    context 'when considering the full live_at' do
      context 'and it is not a real date' do
        let(:live_at_yyyy) { live_at.year.to_s }
        let(:live_at_mm) { '2' }
        let(:live_at_dd) { '30' }

        it 'is not valid and has the correct error message' do
          expect(framework.valid?(:update)).to be false
          expect(framework.errors[:live_at].first).to eq 'Enter a valid \'live at\' date'
        end
      end

      context 'and it is a real date' do
        it 'is valid' do
          expect(framework.valid?(:update)).to be true
        end
      end
    end
  end
end
