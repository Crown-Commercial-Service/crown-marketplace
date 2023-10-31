require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::SpreadsheetImport do
  subject(:import) { create(:facilities_management_rm3830_procurement_spreadsheet_import, procurement: create(:facilities_management_rm3830_procurement, aasm_state: 'detailed_search_bulk_upload', user: create(:user))) }

  describe 'aasm_state' do
    it 'starts at upload state' do
      expect(import.aasm_state).to eq('upload')
    end

    context 'when start_import is called' do
      before do
        allow(FacilitiesManagement::RM3830::UploadSpreadsheetWorker).to receive(:perform_async).with(import.id).and_return(true)
        import.start_import!
      end

      it 'starts the worker' do
        expect(FacilitiesManagement::RM3830::UploadSpreadsheetWorker).to have_received(:perform_async).with(import.id)
      end

      it 'set the state to importing' do
        expect(import.importing?).to be true
      end

      it 'changes the data_import_state to in_progress' do
        expect(import.data_import_state?).to be true
      end
    end

    context 'when succeed is called' do
      context 'when in upload' do
        before { import.succeed! }

        it 'changes the state to succeeded' do
          expect(import.succeeded?).to be true
        end
      end

      context 'when in importing' do
        before do
          import.update(aasm_state: 'importing')
          import.succeed!
        end

        it 'changes the state to succeeded' do
          expect(import.succeeded?).to be true
        end
      end
    end

    context 'when fail is called' do
      context 'when in upload' do
        before { import.fail! }

        it 'changes the state to failed' do
          expect(import.failed?).to be true
        end
      end

      context 'when in importing' do
        before do
          import.update(aasm_state: 'importing')
          import.fail!
        end

        it 'changes the state to failed' do
          expect(import.failed?).to be true
        end
      end
    end
  end

  describe 'data_import_state' do
    before { import.update(aasm_state: 'importing') }

    it 'starts at not_started state' do
      expect(import.data_import_state).to eq('not_started')
    end

    context 'when start_upload is called' do
      before do
        allow(FacilitiesManagement::RM3830::UploadSpreadsheetWorker).to receive(:perform_async).with(import.id).and_return(true)
        import.start_upload!
      end

      it 'starts the worker' do
        expect(FacilitiesManagement::RM3830::UploadSpreadsheetWorker).to have_received(:perform_async).with(import.id)
      end

      it 'set the state to in_progress' do
        expect(import.in_progress?).to be true
      end
    end

    context 'when check_file is called' do
      before do
        import.update(data_import_state: 'in_progress')
        import.check_file!
      end

      it 'changes the state to checking_file' do
        expect(import.checking_file?).to be true
      end
    end

    context 'when process_file is called' do
      before do
        import.update(data_import_state: 'checking_file')
        import.process_file!
      end

      it 'changes the state to processing_file' do
        expect(import.processing_file?).to be true
      end
    end

    context 'when check_processed_data is called' do
      before do
        import.update(data_import_state: 'processing_file')
        import.check_processed_data!
      end

      it 'changes the state to checking_processed_data' do
        expect(import.checking_processed_data?).to be true
      end
    end

    context 'when save_data is called' do
      before do
        import.update(data_import_state: 'checking_processed_data')
        import.save_data!
      end

      it 'changes the state to saving_data' do
        expect(import.saving_data?).to be true
      end
    end

    context 'when data_saved is called' do
      before do
        import.update(data_import_state: 'saving_data')
        import.data_saved!
      end

      it 'changes the state to data_import_succeed' do
        expect(import.data_import_succeed?).to be true
      end

      it 'changes the aasm_state to succeeded' do
        expect(import.succeeded?).to be true
      end
    end

    context 'when fail_data_import is called' do
      before { import.fail_data_import! }

      it 'changes the state to data_import_failed' do
        expect(import.data_import_failed?).to be true
      end

      it 'changes the aasm_state to failed' do
        expect(import.failed?).to be true
      end
    end
  end

  describe 'spreadsheet_file' do
    context 'when not attached' do
      before { import.valid?(:upload) }

      it 'must be uploaded error' do
        expect(import.errors.full_messages.grep(/Select your/).size).to eq(1)
      end
    end

    context 'when wrong type of file' do
      before do
        import.spreadsheet_file.attach(io: Rails.root.join('Gemfile').open, filename: 'Gemfile')
        import.valid?(:upload)
      end

      it 'wrong extension error message' do
        expect(import.errors[:spreadsheet_file]).to include 'The selected file must be a XLSX'
      end

      it 'wrong content type message' do
        expect(import.errors[:spreadsheet_file]).to include 'The selected file does not contain the expected content type'
      end
    end
  end

  describe 'methods for processing errors' do
    before do
      import.update(import_errors:)
    end

    describe '.building_error' do
      let(:import_errors) { { 'Building 1': building_1_errors } }

      context 'when there are no errors on the building' do
        let(:building_1_errors) do
          {
            building_name: 'Building 1',
            building_errors: {}
          }
        end

        it 'returns nil' do
          expect(import.send(:building_error, 1, :building_name)).to be_nil
        end
      end

      context 'when there are errors on the building' do
        let(:building_1_errors) do
          {
            building_name: 'Building 1',
            building_errors: { address_line_1: [{ error: :blank }, { error: :too_long }] }
          }
        end

        it 'returns the error array' do
          expect(import.send(:building_error, 1, :address_line_1).values).to eq ['Building 1', :address_line_1, %w[blank too_long]]
        end
      end
    end

    describe '.building_errors' do
      let(:import_errors) { { 'Building 1': building_1_errors, 'Building 2': building_2_errors, 'Building 3': building_3_errors } }

      context 'when there are no errors on the buildings' do
        let(:building_1_errors) do
          {
            building_name: 'Building 1',
            building_errors: {}
          }
        end
        let(:building_2_errors) do
          {
            building_name: 'Building 2',
            skip: true
          }
        end
        let(:building_3_errors) do
          {
            building_name: 'Building 3',
            building_errors: {}
          }
        end

        it 'returns an empty array' do
          expect(import.building_errors).to eq []
        end
      end

      context 'when there are errors on the buildings' do
        let(:building_1_errors) do
          {
            building_name: 'Building 1',
            building_errors: { building_name: [{ error: :blank }], other_building_type: [{ error: :too_long }] }
          }
        end
        let(:building_2_errors) do
          {
            building_name: 'Building 2',
            skip: true
          }
        end
        let(:building_3_errors) do
          {
            building_name: 'Building 3',
            building_errors: { building_type: [{ error: :inclusion }] }
          }
        end

        it 'returns an array with the errors' do
          error_details = import.building_errors

          expect(error_details[0].values).to eq ['Building 1', :building_name, %w[blank]]
          expect(error_details[1].values).to eq ['Building 1', :other_building_type, %w[too_long]]
          expect(error_details[2].values).to eq ['Building 3', :building_type, %w[inclusion]]
        end
      end
    end

    describe '.service_matrix_error' do
      let(:import_errors) { { 'Building 1': building_1_errors } }

      context 'when there are no errors on the service matrix' do
        let(:building_1_errors) do
          {
            building_name: 'Building 1',
            building_errors: {},
            procurement_building_errors: {}
          }
        end

        it 'returns nil' do
          expect(import.send(:service_matrix_error, 1, :building)).to be_nil
        end
      end

      context 'when there are errors on the service matrix' do
        let(:building_1_errors) do
          {
            building_name: 'Building 1',
            building_errors: {},
            procurement_building_errors: { service_codes: [{ error: :invalid }], building: [{ error: :gia_too_small }] }
          }
        end

        it 'returns the error array' do
          expect(import.send(:service_matrix_error, 1, :building).values).to eq ['Building 1', :building, %w[gia_too_small]]
        end
      end
    end

    describe '.service_matrix_errors' do
      let(:import_errors) { { 'Building 1': building_1_errors, 'Building 2': building_2_errors, 'Building 3': building_3_errors } }

      context 'when there are no errors on the service matrix' do
        let(:building_1_errors) do
          {
            building_name: 'Building 1',
            skip: true
          }
        end
        let(:building_2_errors) do
          {
            building_name: 'Building 2',
            building_errors: {},
            procurement_building_errors: {}
          }
        end
        let(:building_3_errors) do
          {
            building_name: 'Building 3',
            building_errors: {},
            procurement_building_errors: {}
          }
        end

        it 'returns an empty array' do
          expect(import.service_matrix_errors).to eq []
        end
      end

      context 'when there are errors on the service matrix' do
        let(:building_1_errors) do
          {
            building_name: 'Building 1',
            skip: true
          }
        end
        let(:building_2_errors) do
          {
            building_name: 'Building 2',
            building_errors: {},
            procurement_building_errors: { service_codes: [{ error: :invalid }], building: [{ error: :gia_too_small }] }
          }
        end
        let(:building_3_errors) do
          {
            building_name: 'Building 3',
            building_errors: {},
            procurement_building_errors: { service_codes: [{ error: :invalid_cafm_billable }] }
          }
        end

        it 'returns an array with the errors' do
          error_details = import.service_matrix_errors

          expect(error_details[0].values).to eq ['Building 2', :service_codes, %w[invalid]]
          expect(error_details[1].values).to eq ['Building 2', :building, %w[gia_too_small]]
          expect(error_details[2].values).to eq ['Building 3', :service_codes, %w[invalid_cafm_billable]]
        end
      end
    end

    describe '.service_error on volumes' do
      let(:import_errors) { { 'Building 1': building_1_errors } }

      context 'when there are no errors on the service volumes' do
        let(:building_1_errors) do
          {
            building_name: 'Building 1',
            building_errors: {},
            procurement_building_errors: {},
            procurement_building_services_errors: { 'E.4': {} }
          }
        end

        it 'returns nil' do
          expect(import.send(:service_error, 1, 'E.4', :no_of_appliances_for_testing)).to be_nil
        end
      end

      context 'when there are errors on the service volumes' do
        let(:building_1_errors) do
          {
            building_name: 'Building 1',
            building_errors: {},
            procurement_building_errors: {},
            procurement_building_services_errors: { 'E.4': { no_of_appliances_for_testing: [{ error: :blank }] } }
          }
        end

        it 'returns the error array' do
          expect(import.send(:service_error, 1, 'E.4', :no_of_appliances_for_testing).values).to eq ['Building 1', 'Portable appliance testing', :no_of_appliances_for_testing, %w[blank]]
        end
      end
    end

    describe '.service_volume_errors' do
      let(:import_errors) { { 'Building 1': building_1_errors, 'Building 2': building_2_errors, 'Building 3': building_3_errors } }

      context 'when there are no errors on the service volumes' do
        let(:building_1_errors) do
          {
            building_name: 'Building 1',
            building_errors: {},
            procurement_building_errors: {},
            procurement_building_services_errors: {}
          }
        end
        let(:building_2_errors) do
          {
            building_name: 'Building 2',
            skip: true
          }
        end
        let(:building_3_errors) do
          {
            building_name: 'Building 3',
            building_errors: {},
            procurement_building_errors: {},
            procurement_building_services_errors: {}
          }
        end

        it 'returns an empty array' do
          expect(import.service_volume_errors).to eq []
        end
      end

      context 'when there are errors on the service volumes' do
        let(:building_1_errors) do
          {
            building_name: 'Building 1',
            building_errors: {},
            procurement_building_errors: {},
            procurement_building_services_errors: { 'G.1': { no_of_building_occupants: [{ error: :greater_than }] }, 'K.7': { no_of_units_to_be_serviced: [{ error: :blank }] } }
          }
        end
        let(:building_2_errors) do
          {
            building_name: 'Building 2',
            skip: true
          }
        end
        let(:building_3_errors) do
          {
            building_name: 'Building 3',
            building_errors: {},
            procurement_building_errors: {},
            procurement_building_services_errors: { 'K.2': { tones_to_be_collected_and_removed: [{ error: :less_than_or_equal_to }] }, 'C.5': {} }
          }
        end

        it 'returns an array with the errors' do
          error_details = import.service_volume_errors

          expect(error_details[0].values).to eq ['Building 1', 'Routine cleaning', :no_of_building_occupants, %w[invalid]]
          expect(error_details[1].values).to eq ['Building 1', 'Feminine hygiene waste', :no_of_units_to_be_serviced, %w[blank]]
          expect(error_details[2].values).to eq ['Building 3', 'General waste', :tones_to_be_collected_and_removed, %w[invalid]]
        end
      end
    end

    describe '.lift_error' do
      let(:import_errors) { { 'Building 1': building_1_errors } }

      context 'when there are no errors on lifts' do
        let(:building_1_errors) do
          {
            building_name: 'Building 1',
            building_errors: {},
            procurement_building_errors: {},
            procurement_building_services_errors: { 'C.5': {} }
          }
        end

        it 'returns nil' do
          expect(import.send(:lift_error, 1)).to be_nil
        end
      end

      context 'when there are errors on the number of lifts' do
        let(:building_1_errors) do
          {
            building_name: 'Building 1',
            building_errors: {},
            procurement_building_errors: {},
            procurement_building_services_errors: { 'C.5': { lifts: [{ error: :required }] } }
          }
        end

        it 'returns the error array' do
          expect(import.send(:lift_error, 1).values).to eq ['Building 1', 'Lifts, hoists & conveyance systems maintenance', :lifts]
        end
      end

      context 'when there are errors on the number of floors in a lift' do
        let(:building_1_errors) do
          {
            building_name: 'Building 1',
            building_errors: {},
            procurement_building_errors: {},
            procurement_building_services_errors: { 'C.5': { 'lifts[4].number_of_floors': [{ error: :greater_than, value: 0, count: 0 }], 'lifts[6].number_of_floors': [{ error: :greater_than, value: 0, count: 0 }] } }
          }
        end

        it 'returns the error array' do
          expect(import.send(:lift_error, 1).values).to eq ['Building 1', 'Lifts, hoists & conveyance systems maintenance', :number_of_floors]
        end
      end
    end

    describe '.lift_errors' do
      let(:import_errors) { { 'Building 1': building_1_errors, 'Building 2': building_2_errors, 'Building 3': building_3_errors } }

      context 'when there are no errors on the lifts' do
        let(:building_1_errors) do
          {
            building_name: 'Building 1',
            building_errors: {},
            procurement_building_errors: {},
            procurement_building_services_errors: { 'C.5': {}, 'E.4': {} }
          }
        end
        let(:building_2_errors) do
          {
            building_name: 'Building 2',
            skip: true
          }
        end
        let(:building_3_errors) do
          {
            building_name: 'Building 3',
            building_errors: {},
            procurement_building_errors: {},
            procurement_building_services_errors: { 'C.5': {}, 'G.3': {} }
          }
        end

        it 'returns an empty array' do
          expect(import.lift_errors).to eq []
        end
      end

      context 'when there are errors on the lifts' do
        let(:building_1_errors) do
          {
            building_name: 'Building 1',
            building_errors: {},
            procurement_building_errors: {},
            procurement_building_services_errors: { 'C.5': { 'lifts[1].number_of_floors': [{ error: :greater_than, value: 0, count: 0 }], 'lifts[3].number_of_floors': [{ error: :greater_than, value: 0, count: 0 }] }, 'E.4': {} }
          }
        end
        let(:building_2_errors) do
          {
            building_name: 'Building 2',
            skip: true
          }
        end
        let(:building_3_errors) do
          {
            building_name: 'Building 3',
            building_errors: {},
            procurement_building_errors: {},
            procurement_building_services_errors: { 'C.5': { lifts: [{ error: :required }] }, 'G.3': {} }
          }
        end

        it 'returns an array with the errors' do
          error_details = import.lift_errors

          expect(error_details[0].values).to eq ['Building 1', 'Lifts, hoists & conveyance systems maintenance', :number_of_floors]
          expect(error_details[1].values).to eq ['Building 3', 'Lifts, hoists & conveyance systems maintenance', :lifts]
        end
      end
    end

    describe '.service_error on service_hours' do
      let(:import_errors) { { 'Building 1': building_1_errors } }

      context 'when there are no errors on the service volumes' do
        let(:building_1_errors) do
          {
            building_name: 'Building 1',
            building_errors: {},
            procurement_building_errors: {},
            procurement_building_services_errors: { 'H.4': {} }
          }
        end

        it 'returns nil' do
          expect(import.send(:service_error, 1, 'H.4', :service_hours)).to be_nil
        end
      end

      context 'when there are errors on the service volumes' do
        let(:building_1_errors) do
          {
            building_name: 'Building 1',
            building_errors: {},
            procurement_building_errors: {},
            procurement_building_services_errors: { 'H.4': { detail_of_requirement: [{ error: :blank }] } }
          }
        end

        it 'returns the error array' do
          expect(import.send(:service_error, 1, 'H.4', :detail_of_requirement).values).to eq ['Building 1', 'Handyman services', :detail_of_requirement, %w[blank]]
        end
      end
    end

    describe '.service_hour_errors' do
      let(:import_errors) { { 'Building 1': building_1_errors, 'Building 2': building_2_errors, 'Building 3': building_3_errors } }

      context 'when there are no errors on the service volumes' do
        let(:building_1_errors) do
          {
            building_name: 'Building 1',
            building_errors: {},
            procurement_building_errors: {},
            procurement_building_services_errors: { 'H.4': {}, 'I.4': {} }
          }
        end
        let(:building_2_errors) do
          {
            building_name: 'Building 2',
            building_errors: {},
            procurement_building_errors: {},
            procurement_building_services_errors: { 'J.4': {} }
          }
        end
        let(:building_3_errors) do
          {
            building_name: 'Building 3',
            skip: true
          }
        end

        it 'returns an empty array' do
          expect(import.service_hour_errors).to eq []
        end
      end

      context 'when there are errors on the service volumes' do
        let(:building_1_errors) do
          {
            building_name: 'Building 1',
            building_errors: {},
            procurement_building_errors: {},
            procurement_building_services_errors: { 'H.4': { service_hours: [{ error: :not_a_number }] }, 'I.4': {} }
          }
        end
        let(:building_2_errors) do
          {
            building_name: 'Building 2',
            building_errors: {},
            procurement_building_errors: {},
            procurement_building_services_errors: { 'J.4': { service_hours: [{ error: :greater_than_or_equal_to }], detail_of_requirement: [{ error: :blank }] } }
          }
        end
        let(:building_3_errors) do
          {
            building_name: 'Building 3',
            skip: true
          }
        end

        it 'returns an array with the errors' do
          error_details = import.service_hour_errors

          expect(error_details[0].values).to eq ['Building 1', 'Handyman services', :service_hours, %w[not_a_number]]
          expect(error_details[1].values).to eq ['Building 2', 'Emergency response', :service_hours, %w[greater_than_or_equal_to]]
          expect(error_details[2].values).to eq ['Building 2', 'Emergency response', :detail_of_requirement, %w[blank]]
        end
      end
    end
  end
end
