require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::Admin::ManagementReportCsvGenerator do
  let(:management_report_csv_generator) { described_class.new(management_report.id) }
  let(:management_report) { create(:facilities_management_rm3830_admin_management_report, user: create(:user), start_date: start_date, end_date: end_date) }
  let(:start_date) { Time.zone.today - 1.year }
  let(:end_date) { Time.zone.today - 1.day }

  before { allow(FacilitiesManagement::RM3830::Admin::ManagementReportWorker).to receive(:perform_async).with(anything).and_return(true) }

  describe ':initialize' do
    it 'finds the management report' do
      expect(management_report_csv_generator.instance_variable_get(:@management_report)).to eq management_report
    end

    it 'sets the dates' do
      expect(management_report_csv_generator.instance_variable_get(:@start_date)).to eq start_date
      expect(management_report_csv_generator.instance_variable_get(:@end_date)).to eq end_date
    end
  end

  describe ':generate' do
    before do
      allow(FacilitiesManagement::RM3830::Admin::ProcurementCsvExport).to receive(:call).with(start_date, end_date).and_return('')
      management_report_csv_generator.generate
      management_report.reload
    end

    it 'attaches the file to the management report' do
      expect(management_report.management_report_csv).to be_attached
    end

    it 'attaches the file with the correct filename' do
      expect(management_report.management_report_csv.content_type).to eq 'text/csv'
    end

    it 'attaches the file with the correct content type' do
      created_at_string = management_report.created_at.in_time_zone('London').strftime '%Y%m%d-%H%M'
      start_date_string = start_date.strftime '%Y%m%d'
      end_date_string = end_date.strftime '%Y%m%d'

      expect(management_report.management_report_csv.filename.to_s).to eq "procurements_data_#{created_at_string}_#{start_date_string}-#{end_date_string}.csv"
    end

    it 'changes the management_report to completed' do
      expect(management_report.completed?).to be true
    end
  end
end
