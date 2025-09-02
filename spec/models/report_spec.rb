require 'rails_helper'

RSpec.describe Report do
  let(:report) { create(:report) }

  before { allow(ReportWorker).to receive(:perform_async) }

  describe 'associations' do
    it { is_expected.to belong_to(:framework) }
    it { is_expected.to belong_to(:user) }

    it 'has the framework relationship' do
      expect(report.framework).to be_present
    end

    it 'has the user relationship' do
      expect(report.user).to be_present
    end
  end

  describe 'creating report' do
    before { report }

    context 'when the report does not have a report_csv' do
      it 'calls perform_async on ReportWorker' do
        expect(ReportWorker).to have_received(:perform_async).with(report.id)
      end
    end

    context 'when the report have a report_csv' do
      let(:report) { create(:report, :with_report) }

      it 'does not call calls perform_async on ReportWorker' do
        expect(ReportWorker).not_to have_received(:perform_async)
      end
    end
  end

  describe 'report state' do
    before { report }

    it 'has generating_csv as the inital state' do
      expect(report.aasm_state).to eq('generating_csv')
    end

    context 'when the complete transition is called' do
      before { report.complete! }

      it "has the state 'completed'" do
        expect(report.aasm_state).to eq('completed')
      end
    end

    context 'when the fail transition is called' do
      before { report.fail! }

      it "has the state 'failed'" do
        expect(report.aasm_state).to eq('failed')
      end
    end
  end

  describe 'validations' do
    context 'when the start date is blank' do
      before do
        report.start_date_dd = ''
        report.start_date_mm = ''
        report.start_date_yyyy = ''

        report.save
      end

      it 'verifies that the start date is a valid date' do
        expect(report.errors.of_kind?(:start_date, :not_a_date)).to be true
      end

      it 'has the correct error message' do
        expect(report.errors[:start_date].first).to eq 'Enter a valid ‘From’ date'
      end
    end

    context 'when the end date is blank' do
      before do
        report.end_date_dd = ''
        report.end_date_mm = ''
        report.end_date_yyyy = ''

        report.save
      end

      it 'verifies that the end date is a valid date' do
        expect(report.errors.of_kind?(:end_date, :not_a_date)).to be true
      end

      it 'has the correct error message' do
        expect(report.errors[:end_date].first).to eq 'Enter a valid ‘To’ date'
      end
    end

    context 'when the start date is invalid' do
      before do
        report.start_date_dd = '88'
        report.start_date_mm = '8'
        report.start_date_yyyy = '2020'

        report.save
      end

      it 'verifies that the start date is a valid date' do
        expect(report.errors.of_kind?(:start_date, :not_a_date)).to be true
      end

      it 'has the correct error message' do
        expect(report.errors[:start_date].first).to eq 'Enter a valid ‘From’ date'
      end
    end

    context 'when the end date is invalid' do
      before do
        report.end_date_dd = '88'
        report.end_date_mm = '8'
        report.end_date_yyyy = '2020'

        report.save
      end

      it 'verifies that the end date is a valid date' do
        expect(report.errors.of_kind?(:end_date, :not_a_date)).to be true
      end

      it 'has the correct error message' do
        expect(report.errors[:end_date].first).to eq 'Enter a valid ‘To’ date'
      end
    end

    context 'when the start date is in the past' do
      before do
        report.start_date = Time.zone.today + 1.day

        report.save
      end

      it 'verifies that the start date is date in the past' do
        expect(report.errors.of_kind?(:start_date, :date_before_or_equal_to)).to be true
      end

      it 'has the correct error message' do
        expect(report.errors[:start_date].first).to eq 'The ‘From’ date must be today or in the past'
      end
    end

    context 'when the end date is in the past' do
      before do
        report.end_date = Time.zone.today + 1.day

        report.save
      end

      it 'verifies that the end date is date in the past' do
        expect(report.errors.of_kind?(:end_date, :date_before_or_equal_to)).to be true
      end

      it 'has the correct error message' do
        expect(report.errors[:end_date].first).to eq 'The ‘To’ date must be today or in the past'
      end
    end

    context 'when the start date is before or equal to the end date' do
      before do
        report.start_date = Time.zone.today
        report.end_date = Time.zone.today - 1.day

        report.save
      end

      it 'is not valid' do
        expect(report.errors.of_kind?(:end_date, :date_after_or_equal_to)).to be true
      end

      it 'has the correct error message' do
        expect(report.errors[:end_date].first).to eq 'The ‘To’ date must be the same or after the ‘From’ date'
      end
    end

    context 'when the start date is equal to the end date' do
      before do
        report.start_date = Time.zone.today
        report.end_date = Time.zone.today
      end

      it 'is valid' do
        expect(report.valid?).to be(true)
      end
    end
  end

  describe 'short_uuid' do
    it 'returns the shortened uuid' do
      expect(report.short_uuid).to eq("##{report.id[..7]}")
    end
  end
end
