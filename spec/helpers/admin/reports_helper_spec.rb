require 'rails_helper'

RSpec.describe Admin::ReportsHelper do
  describe 'upload_status_tag' do
    let(:status_tag) { helper.upload_status_tag(status) }

    context 'when the status is generating_csv' do
      let(:status) { 'generating_csv' }

      it 'returns Generating report and grey' do
        expect(status_tag).to eq ['Generating report', :grey]
      end
    end

    context 'when the status is completed' do
      let(:status) { 'completed' }

      it 'returns Report generated' do
        expect(status_tag).to eq ['Report generated']
      end
    end

    context 'when the status is failed' do
      let(:status) { 'failed' }

      it 'returns Generating failed and red' do
        expect(status_tag).to eq ['Generating failed', :red]
      end
    end
  end
end
