require 'rails_helper'

RSpec.describe Admin::UploadsHelper do
  describe 'upload_status_tag' do
    let(:status_tag) { helper.upload_status_tag(status) }

    context 'when the status is not_started' do
      let(:status) { 'not_started' }

      it 'returns In progress and grey' do
        expect(status_tag).to eq ['In progress', :grey]
      end
    end

    context 'when the status is in_progress' do
      let(:status) { 'in_progress' }

      it 'returns In progress and grey' do
        expect(status_tag).to eq ['In progress', :grey]
      end
    end

    context 'when the status is checking_files' do
      let(:status) { 'checking_files' }

      it 'returns In progress and grey' do
        expect(status_tag).to eq ['In progress', :grey,]
      end
    end

    context 'when the status is processing_files' do
      let(:status) { 'processing_files' }

      it 'returns In progress and grey' do
        expect(status_tag).to eq ['In progress', :grey]
      end
    end

    context 'when the status is checking_processed_data' do
      let(:status) { 'checking_processed_data' }

      it 'returns In progress and grey' do
        expect(status_tag).to eq ['In progress', :grey]
      end
    end

    context 'when the status is publishing_data' do
      let(:status) { 'publishing_data' }

      it 'returns In progress and grey' do
        expect(status_tag).to eq ['In progress', :grey]
      end
    end

    context 'when the status is published' do
      let(:status) { 'published' }

      it 'returns Published on live' do
        expect(status_tag).to eq ['Published on live']
      end
    end

    context 'when the status is failed' do
      let(:status) { 'failed' }

      it 'returns Failed and red' do
        expect(status_tag).to eq ['Failed', :red]
      end
    end
  end
end
