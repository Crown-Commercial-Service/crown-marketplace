require 'rails_helper'

RSpec.describe FacilitiesManagement::Admin::ManagementReport, type: :model do
  subject(:management_report) { build(:facilities_management_admin_management_report, user: user) }

  let(:user) { create(:user) }

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:start_date) }
    it { is_expected.to validate_presence_of(:end_date) }

    it 'verifies that the start date is a valid date' do
      management_report.start_date_dd = '88'
      management_report.start_date_mm = '8'
      management_report.start_date_yyyy = '2020'

      management_report.save

      expect(management_report.errors.details[:start_date].first.dig(:error)).to eq(:not_a_date)
    end

    it 'verifies that the end date is a valid date' do
      management_report.end_date_dd = '88'
      management_report.end_date_mm = '8'
      management_report.end_date_yyyy = '2020'

      management_report.save

      expect(management_report.errors.details[:end_date].first.dig(:error)).to eq(:not_a_date)
    end

    it 'verifies that the start date is date in the past' do
      management_report.start_date = Time.zone.today + 1.day

      management_report.save

      expect(management_report.errors.details[:start_date].first.dig(:error)).to eq(:date_before_or_equal_to)
    end

    it 'verifies that the end date is date in the past' do
      management_report.end_date = Time.zone.today + 1.day

      management_report.save

      expect(management_report.errors.details[:end_date].first.dig(:error)).to eq(:date_before_or_equal_to)
    end

    it 'verifies that the start date is before or equal to the end date' do
      management_report.start_date = Time.zone.today
      management_report.end_date = Time.zone.today - 1.day

      management_report.save

      expect(management_report.errors.details[:end_date].first.dig(:error)).to eq(:must_be_before_start_date)

      management_report.end_date = Time.zone.today

      expect(management_report.valid?).to eq(true)
    end
  end
end
