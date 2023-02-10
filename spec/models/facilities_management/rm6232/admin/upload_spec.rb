require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6232::Admin::Upload do
  let(:upload) { create(:facilities_management_rm6232_admin_upload) }
  let(:valid_file) { Tempfile.new(['valid_file', '.xlsx']) }
  let(:text_file) { Tempfile.new(['text_file', '.txt']) }
  let(:invalid_file) { Tempfile.new(['invalid_file', '.xlsx']) }
  let(:valid_file_path) { fixture_file_upload(valid_file.path, 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet') }
  let(:text_file_path) { fixture_file_upload(text_file.path, 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet') }
  let(:invalid_file_path) { fixture_file_upload(invalid_file.path, 'application/pdft') }

  after do
    valid_file.unlink
    text_file.unlink
    invalid_file.unlink
  end

  describe 'validations' do
    context 'when considering if the files are attached' do
      context 'and no files are attached' do
        it 'is not valid and has the correct error messages' do
          expect(upload.valid?(:upload)).to be false
          expect(upload.errors.messages.values.flatten).to match ["Select the 'Supplier details' file", "Select the 'Supplier services' file", "Select the 'Supplier regions' file"]
        end
      end

      context 'and two files are attached' do
        before do
          upload.supplier_details_file = valid_file_path
          upload.supplier_services_file = valid_file_path
        end

        it 'is not valid and has the correct error messages' do
          expect(upload.valid?(:upload)).to be false
          expect(upload.errors.messages.values.flatten).to match ["Select the 'Supplier regions' file"]
        end
      end
    end

    context 'when considering the file extension' do
      context 'and the files do not have the correct file extension' do
        before do
          upload.supplier_details_file = text_file_path
          upload.supplier_services_file = text_file_path
          upload.supplier_regions_file = text_file_path
        end

        it 'is not valid and has the correct error messages' do
          expect(upload.valid?(:upload)).to be false
          expect(upload.errors.messages.values.flatten).to match ["The 'Supplier details' file must be an XLSX", "The 'Supplier services' file must be an XLSX", "The 'Supplier regions' file must be an XLSX"]
        end
      end

      context 'and two files do not have the correct file extension' do
        before do
          upload.supplier_details_file = text_file_path
          upload.supplier_services_file = valid_file_path
          upload.supplier_regions_file = text_file_path
        end

        it 'is not valid and has the correct error messages' do
          expect(upload.valid?(:upload)).to be false
          expect(upload.errors.messages.values.flatten).to match ["The 'Supplier details' file must be an XLSX", "The 'Supplier regions' file must be an XLSX"]
        end
      end
    end

    context 'when considering the file content type' do
      context 'and the files do not have the correct content type' do
        before do
          upload.supplier_details_file = invalid_file_path
          upload.supplier_services_file = invalid_file_path
          upload.supplier_regions_file = invalid_file_path
        end

        it 'is not valid and has the correct error messages' do
          expect(upload.valid?(:upload)).to be false
          expect(upload.errors.messages.values.flatten).to match ["The 'Supplier details' file does not contain the expected content type", "The 'Supplier services' file does not contain the expected content type", "The 'Supplier regions' file does not contain the expected content type"]
        end
      end

      context 'and two files do not have the correct content type' do
        before do
          upload.supplier_details_file = valid_file_path
          upload.supplier_services_file = invalid_file_path
          upload.supplier_regions_file = invalid_file_path
        end

        it 'is not valid and has the correct error messages' do
          expect(upload.valid?(:upload)).to be false
          expect(upload.errors.messages.values.flatten).to match ["The 'Supplier services' file does not contain the expected content type", "The 'Supplier regions' file does not contain the expected content type"]
        end
      end
    end

    context 'and the files are valid' do
      before do
        upload.supplier_details_file = valid_file_path
        upload.supplier_services_file = valid_file_path
        upload.supplier_regions_file = valid_file_path
      end

      it 'is valid' do
        expect(upload.valid?(:upload)).to be true
      end
    end
  end

  describe 'aasm_state' do
    it 'starts in the not_started state' do
      expect(upload.aasm_state).to eq('not_started')
    end

    context 'when start_upload is called' do
      before do
        allow(FacilitiesManagement::RM6232::Admin::FileUploadWorker).to receive(:perform_async).with(upload.id).and_return(true)
        upload.start_upload!
      end

      it 'changes the state to in_progress' do
        expect(upload.in_progress?).to be true
      end

      it 'starts the worker' do
        expect(FacilitiesManagement::RM6232::Admin::FileUploadWorker).to have_received(:perform_async).with(upload.id)
      end
    end

    context 'when check_file is called' do
      before { upload.update(aasm_state: 'in_progress') }

      it 'changes the state to checking_files' do
        upload.check_files!

        expect(upload.checking_files?).to be true
      end
    end

    context 'when process_file is called' do
      before { upload.update(aasm_state: 'checking_files') }

      it 'changes the state to processing_files' do
        upload.process_files!

        expect(upload.processing_files?).to be true
      end
    end

    context 'when check_processed_data is called' do
      before { upload.update(aasm_state: 'processing_files') }

      it 'changes the state to checking_processed_data' do
        upload.check_processed_data!

        expect(upload.checking_processed_data?).to be true
      end
    end

    context 'when publish_data is called' do
      before { upload.update(aasm_state: 'checking_processed_data') }

      it 'changes the state to publishing_data' do
        upload.publish_data!

        expect(upload.publishing_data?).to be true
      end
    end

    context 'when publish is called' do
      before { upload.update(aasm_state: 'publishing_data') }

      it 'changes the state to published' do
        upload.publish!

        expect(upload.published?).to be true
      end
    end

    context 'when fail is called' do
      it 'changes the state to failed' do
        upload.fail!

        expect(upload.failed?).to be true
      end
    end
  end

  describe 'short_uuid' do
    it 'contains the first half of the uuid' do
      expect(upload.id).to start_with upload.short_uuid
    end
  end

  describe 'latest_upload' do
    context 'and there are published uploads' do
      let(:latest_upload) { described_class.create(aasm_state: 'published') }

      before do
        4.times { described_class.create(aasm_state: 'published', created_at: 1.day.ago) }
        latest_upload
      end

      it 'is the latest published upload' do
        expect(described_class.latest_upload).to eq latest_upload
      end
    end

    context 'and there are no published uploads' do
      before { 5.times { described_class.create } }

      it 'is nil' do
        expect(described_class.latest_upload).to be_nil
      end
    end
  end
end
