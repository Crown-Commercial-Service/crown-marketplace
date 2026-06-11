require 'rails_helper'

RSpec.describe ReportCsvGenerator do
  let(:report_csv_generator) { described_class.new(report.id) }
  let(:report) { create(:report, framework: Framework.find('RM6378')) }

  before { allow(ReportWorker).to receive(:perform_async) }

  describe 'initialise' do
    it 'sets the report' do
      expect(report_csv_generator.instance_variable_get(:@report)).to eq(report)
    end

    it 'sets the report_generator_class' do
      expect(report_csv_generator.instance_variable_get(:@report_generator_class)).to eq(FacilitiesManagement::RM6378::Admin::ReportExport)
    end
  end

  describe 'generate' do
    context 'when the upload succeeds' do
      before do
        allow(FacilitiesManagement::RM6378::Admin::ReportExport).to receive(:call).with(report).and_return('')
        report_csv_generator.generate
        report.reload
      end

      it 'attaches the file to the report' do
        expect(report.report_csv).to be_attached
      end

      it 'attaches the file with the correct filename' do
        expect(report.report_csv.content_type).to eq 'text/csv'
      end

      it 'attaches the file with the correct content type' do
        created_at_string = report.created_at.in_time_zone('London').strftime '%Y%m%d-%H%M'
        start_date_string = report.start_date.strftime '%Y%m%d'
        end_date_string = report.end_date.strftime '%Y%m%d'

        expect(report.report_csv.filename.to_s).to eq "facilities_management_rm6378_#{created_at_string}_#{start_date_string}-#{end_date_string}.csv"
      end

      it 'changes the report to completed' do
        expect(report.completed?).to be true
      end
    end

    context 'when the generation job fails' do
      before do
        allow(FacilitiesManagement::RM6378::Admin::ReportExport).to receive(:call).with(report).and_raise(StandardError.new('Some message'))
        report_csv_generator.generate
        report.reload
      end

      it 'attaches the file to the report' do
        expect(report.report_csv).not_to be_attached
      end

      it 'changes the report to failed' do
        expect(report.failed?).to be true
      end
    end
  end
end
