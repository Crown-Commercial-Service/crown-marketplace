require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::SpreadsheetImporter, type: :service do
  let(:spreadsheet_import) do
    create(:facilities_management_rm3830_procurement_spreadsheet_import, procurement: procurement, aasm_state: 'importing', data_import_state: 'in_progress') do |import|
      import.spreadsheet_file.attach(io: File.open(spreadsheet_path), filename: 'test.xlsx')
    end
  end

  let(:fake_spreadsheet) { SpreadsheetImportHelper::FakeBulkUploadSpreadsheet.new }
  let(:spreadsheet_path) { SpreadsheetImportHelper::FakeBulkUploadSpreadsheet::OUTPUT_PATH }
  let(:spreadsheet_importer) { described_class.new(spreadsheet_import) }
  let(:import_process_order) { described_class::IMPORT_PROCESS_ORDER }
  let(:spreadsheet_importer_errors) { spreadsheet_importer.instance_variable_get(:@errors) }
  let(:process_file_order) { %i[import_buildings add_procurement_buildings import_service_matrix import_service_volumes import_lift_data import_service_hours validate_procurement_building_services] }

  describe '#basic_data_validation' do
    let(:procurement) { build(:facilities_management_rm3830_procurement_detailed_search) }

    before { spreadsheet_importer.send(:check_file) }

    describe 'template validation' do
      context 'when uploaded file is true to template' do
        let(:spreadsheet_path) { described_class::TEMPLATE_FILE_PATH }

        it 'the error is not_started' do
          expect(spreadsheet_importer_errors).to eq({ other_errors: { file_check_error: :not_started } })
        end
      end

      context 'when uploaded file differs from template' do
        let(:spreadsheet_path) do
          Rails.root.join('data', 'facilities_management', 'rm3830', 'RM3830 Suppliers Details (for Dev & Test).xlsx')
        end

        it 'includes template invalid error' do
          expect(spreadsheet_importer_errors).to eq({ other_errors: { file_check_error: :template_invalid } })
        end
      end
    end
  end

  # rubocop:disable RSpec/NestedGroups
  describe '#import_buildings' do
    before do
      fake_spreadsheet.add_building_sheet(building_data)
      fake_spreadsheet.write

      # Stub out import methods not under test
      allow(spreadsheet_importer).to receive_messages(check_file: nil, procurement_buildings_valid?: true, procurement_building_services_valid?: true, service_codes: ['C.1'])

      (process_file_order - %i[import_buildings]).each do |other_process_method|
        allow(spreadsheet_importer).to receive(other_process_method).and_return(nil)
      end

      allow(spreadsheet_importer).to receive(:save_procurement_building).with(anything).and_return(nil)
      allow(spreadsheet_importer).to receive(:save_procurement_building_services).with(anything).and_return(nil)

      allow(FacilitiesManagement::RM3830::SpreadsheetImport).to receive(:find_by).and_return(true)
      allow(FacilitiesManagement::RM3830::SpreadsheetImport).to receive(:find_by).with(anything).and_return(true)

      spreadsheet_importer.import_data
    end

    let(:procurement) { create(:facilities_management_rm3830_procurement, user:) }
    let(:user) { create(:user) }
    let(:spreadsheet_building) { create(:facilities_management_building) }
    let(:spreadsheet_building_2) { create(:facilities_management_building, building_name: spreadsheet_building.building_name) }

    describe 'import with valid data' do
      let(:building_data) { [[spreadsheet_building, 'Complete']] }

      it 'saves the data correctly' do
        acceptable_attributes = %w[building_name description address_line_1 address_line_2 address_town gia external_area building_type other_building_type security_type other_security_type]
        expect(user.buildings.first.attributes.slice(*acceptable_attributes)).to eq spreadsheet_building.attributes.slice(*acceptable_attributes)
      end

      it 'changes the state of the spreadsheet_import to succeeded' do
        spreadsheet_import.reload
        expect(spreadsheet_import.succeeded?).to be true
      end
    end

    describe 'import with no buildings' do
      let(:building_data) { [] }

      it 'changes the state of the spreadsheet_import to failed' do
        spreadsheet_import.reload
        expect(spreadsheet_import.failed?).to be true
      end

      it 'has the correct error' do
        expect(spreadsheet_importer_errors).to include(:building_incomplete)
      end
    end

    describe 'import with some buildings not complete' do
      let(:building_data) { [[spreadsheet_building, 'Incomplete'], [spreadsheet_building_2, 'Complete']] }

      it 'changes the state of the spreadsheet_import to failed' do
        spreadsheet_import.reload
        expect(spreadsheet_import.failed?).to be true
      end

      it 'has the correct error' do
        expect(spreadsheet_importer_errors).to include(:building_incomplete)
      end
    end

    describe 'import with invalid data' do
      describe 'building_name' do
        context 'when the building name is blank' do
          let(:spreadsheet_building) { create(:facilities_management_building, building_name: '') }
          let(:building_data) { [[spreadsheet_building, 'Complete']] }

          it 'changes the state of the spreadsheet_import to failed' do
            spreadsheet_import.reload
            expect(spreadsheet_import.failed?).to be true
          end

          it 'makes the building invalid and has the correct error' do
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:valid]).to be false
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:errors][:building_name].first[:error]).to eq :blank
          end
        end

        context 'when the building name is more than the max characters' do
          let(:spreadsheet_building) { create(:facilities_management_building, building_name: 'a' * 51) }
          let(:building_data) { [[spreadsheet_building, 'Complete']] }

          it 'changes the state of the spreadsheet_import to failed' do
            spreadsheet_import.reload
            expect(spreadsheet_import.failed?).to be true
          end

          it 'makes the building invalid and has the correct error' do
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:valid]).to be false
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:errors][:building_name].first[:error]).to eq :too_long
          end
        end

        context 'when the building name is duplicated' do
          let(:building_data) { [[spreadsheet_building, 'Complete'], [spreadsheet_building_2, 'Complete']] }

          it 'changes the state of the spreadsheet_import to failed' do
            spreadsheet_import.reload
            expect(spreadsheet_import.failed?).to be true
          end

          it 'makes the building invalid and has the correct error' do
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).last[:valid]).to be false
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).last[:object].errors.details[:building_name].first[:error]).to eq :taken
          end
        end
      end

      describe 'building_description' do
        context 'when the building description is more than the max characters' do
          let(:spreadsheet_building) { create(:facilities_management_building, description: 'a' * 51) }
          let(:building_data) { [[spreadsheet_building, 'Complete']] }

          it 'changes the state of the spreadsheet_import to failed' do
            spreadsheet_import.reload
            expect(spreadsheet_import.failed?).to be true
          end

          it 'makes the building invalid and has the correct error' do
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:valid]).to be false
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:errors][:description].first[:error]).to eq :too_long
          end
        end
      end

      describe 'address_line_1' do
        context 'when the address_line_1 is blank' do
          let(:spreadsheet_building) { create(:facilities_management_building, address_line_1: '') }
          let(:building_data) { [[spreadsheet_building, 'Complete']] }

          it 'changes the state of the spreadsheet_import to failed' do
            spreadsheet_import.reload
            expect(spreadsheet_import.failed?).to be true
          end

          it 'makes the building invalid and has the correct error' do
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:valid]).to be false
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:errors][:address_line_1].first[:error]).to eq :blank
          end
        end

        context 'when the address_line_1 is more than the max characters' do
          let(:spreadsheet_building) { create(:facilities_management_building, address_line_1: 'a' * 101) }
          let(:building_data) { [[spreadsheet_building, 'Complete']] }

          it 'changes the state of the spreadsheet_import to failed' do
            spreadsheet_import.reload
            expect(spreadsheet_import.failed?).to be true
          end

          it 'makes the building invalid has the correct error' do
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:valid]).to be false
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:errors][:address_line_1].first[:error]).to eq :too_long
          end
        end
      end

      describe 'address_line_2' do
        let(:spreadsheet_building) { create(:facilities_management_building, address_line_2:) }
        let(:building_data) { [[spreadsheet_building, 'Complete']] }

        context 'when the address_line_2 is blank' do
          let(:address_line_2) { '' }

          it 'changes the state of the spreadsheet_import to succeeded' do
            spreadsheet_import.reload
            expect(spreadsheet_import.succeeded?).to be true
          end
        end

        context 'when the address_line_2 is more than the max characters' do
          let(:address_line_2) { 'a' * 101 }

          it 'changes the state of the spreadsheet_import to failed' do
            spreadsheet_import.reload
            expect(spreadsheet_import.failed?).to be true
          end

          it 'makes the building invalid and has the correct error' do
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:valid]).to be false
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:errors][:address_line_2].first[:error]).to eq :too_long
          end
        end
      end

      describe 'address_town' do
        context 'when the address_town is blank' do
          let(:spreadsheet_building) { create(:facilities_management_building, address_town: '') }
          let(:building_data) { [[spreadsheet_building, 'Complete']] }

          it 'changes the state of the spreadsheet_import to failed' do
            spreadsheet_import.reload
            expect(spreadsheet_import.failed?).to be true
          end

          it 'makes the building invalid and has the correct error' do
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:valid]).to be false
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:errors][:address_town].first[:error]).to eq :blank
          end
        end

        context 'when the address_town is more than the max characters' do
          let(:spreadsheet_building) { create(:facilities_management_building, address_town: 'a' * 31) }
          let(:building_data) { [[spreadsheet_building, 'Complete']] }

          it 'changes the state of the spreadsheet_import to failed' do
            spreadsheet_import.reload
            expect(spreadsheet_import.failed?).to be true
          end

          it 'makes the building invalid and has the correct error' do
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:valid]).to be false
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:errors][:address_town].first[:error]).to eq :too_long
          end
        end
      end

      describe 'address_postcode' do
        context 'when the address_postcode is blank' do
          let(:spreadsheet_building) { create(:facilities_management_building, address_postcode: '') }
          let(:building_data) { [[spreadsheet_building, 'Complete']] }

          it 'changes the state of the spreadsheet_import to failed' do
            spreadsheet_import.reload
            expect(spreadsheet_import.failed?).to be true
          end

          it 'makes the building invalid has the correct error' do
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:valid]).to be false
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:errors][:address_postcode].first[:error]).to eq :blank
          end
        end

        context 'when the address_postcode is not a valid format' do
          let(:spreadsheet_building) { create(:facilities_management_building, address_postcode: 'S143 0VV 0VV') }
          let(:building_data) { [[spreadsheet_building, 'Complete']] }

          it 'changes the state of the spreadsheet_import to failed' do
            spreadsheet_import.reload
            expect(spreadsheet_import.failed?).to be true
          end

          it 'makes the building invalid has the correct error' do
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:valid]).to be false
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:errors][:address_postcode].first[:error]).to eq :invalid
          end
        end
      end

      describe 'building area' do
        context 'when the gia is blank' do
          let(:spreadsheet_building) { create(:facilities_management_building, gia: '') }
          let(:building_data) { [[spreadsheet_building, 'Complete']] }

          it 'changes the state of the spreadsheet_import to failed' do
            spreadsheet_import.reload
            expect(spreadsheet_import.failed?).to be true
          end

          it 'makes the building invalid has the correct error' do
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:valid]).to be false
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:errors][:gia].first[:error]).to eq :blank
          end
        end

        context 'when the external_area is blank' do
          let(:spreadsheet_building) { create(:facilities_management_building, external_area: '') }
          let(:building_data) { [[spreadsheet_building, 'Complete']] }

          it 'changes the state of the spreadsheet_import to failed' do
            spreadsheet_import.reload
            expect(spreadsheet_import.failed?).to be true
          end

          it 'makes the building invalid has the correct error' do
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:valid]).to be false
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:errors][:external_area].first[:error]).to eq :blank
          end
        end

        context 'when the gia is not numeric' do
          let(:spreadsheet_building) { create(:facilities_management_building).tap { |b| allow(b).to receive(:gia).and_return('abc') } }
          let(:building_data) { [[spreadsheet_building, 'Complete']] }

          it 'changes the state of the spreadsheet_import to failed' do
            spreadsheet_import.reload
            expect(spreadsheet_import.failed?).to be true
          end

          it 'makes the building invalid and has the correct error' do
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:valid]).to be false
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:errors][:gia].first[:error]).to eq :not_a_number
          end
        end

        context 'when the external_area is not numeric' do
          let(:spreadsheet_building) do
            create(:facilities_management_building).tap { |b| allow(b).to receive(:external_area).and_return('abc') }
          end

          let(:building_data) { [[spreadsheet_building, 'Complete']] }

          it 'changes the state of the spreadsheet_import to failed' do
            spreadsheet_import.reload
            expect(spreadsheet_import.failed?).to be true
          end

          it 'makes the building invalid and has the correct error' do
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:valid]).to be false
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:errors][:external_area].first[:error]).to eq :not_a_number
          end
        end

        context 'when the gia is too large' do
          let(:spreadsheet_building) { create(:facilities_management_building, gia: 1000000000) }
          let(:building_data) { [[spreadsheet_building, 'Complete']] }

          it 'changes the state of the spreadsheet_import to failed' do
            spreadsheet_import.reload
            expect(spreadsheet_import.failed?).to be true
          end

          it 'makes the building invalid and has the correct error' do
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:valid]).to be false
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:errors][:gia].first[:error]).to eq :less_than_or_equal_to
          end
        end

        context 'when the external_area is too large' do
          let(:spreadsheet_building) { create(:facilities_management_building, external_area: 1000000000) }
          let(:building_data) { [[spreadsheet_building, 'Complete']] }

          it 'changes the state of the spreadsheet_import to failed' do
            spreadsheet_import.reload
            expect(spreadsheet_import.failed?).to be true
          end

          it 'makes the building invalid and has the correct error' do
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:valid]).to be false
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:errors][:external_area].first[:error]).to eq :less_than_or_equal_to
          end
        end

        context 'when the gia and external area are zero' do
          let(:spreadsheet_building) { create(:facilities_management_building, gia: 0, external_area: 0) }
          let(:building_data) { [[spreadsheet_building, 'Complete']] }

          it 'changes the state of the spreadsheet_import to failed' do
            spreadsheet_import.reload
            expect(spreadsheet_import.failed?).to be true
          end

          it 'makes the building invalid and has the correct error' do
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:valid]).to be false
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:errors][:gia].first[:error]).to eq :combined_area
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:errors][:external_area].first[:error]).to eq :combined_area
          end
        end
      end

      describe 'building_type' do
        context 'when the building_type is blank' do
          let(:spreadsheet_building) { create(:facilities_management_building, building_type: nil) }
          let(:building_data) { [[spreadsheet_building, 'Complete']] }

          it 'changes the state of the spreadsheet_import to failed' do
            spreadsheet_import.reload
            expect(spreadsheet_import.failed?).to be true
          end

          it 'makes the building invalid and has the correct error has the correct error' do
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:valid]).to be false
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:errors][:building_type].first[:error]).to eq :blank
          end
        end

        context 'when the building_type is not in the list' do
          let(:spreadsheet_building) { create(:facilities_management_building, building_type: 'House') }
          let(:building_data) { [[spreadsheet_building, 'Complete']] }

          it 'changes the state of the spreadsheet_import to failed' do
            spreadsheet_import.reload
            expect(spreadsheet_import.failed?).to be true
          end

          it 'makes the building invalid and has the correct error' do
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:valid]).to be false
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:errors][:building_type].first[:error]).to eq :inclusion
          end
        end

        context 'when the building_type is Other' do
          let(:spreadsheet_building) { create(:facilities_management_building, building_type: 'Other', other_building_type: 'Spanish Villa') }
          let(:building_data) { [[spreadsheet_building, 'Complete']] }

          it 'changes the state of the spreadsheet_import to succeeded' do
            spreadsheet_import.reload
            expect(spreadsheet_import.succeeded?).to be true
          end

          it 'saves the building type as lower case other' do
            expect(user.buildings.first.building_type).to eq 'other'
          end
        end

        context 'when the building_type is other and other is blank' do
          let(:spreadsheet_building) { create(:facilities_management_building, building_type: 'Other', other_building_type: nil) }
          let(:building_data) { [[spreadsheet_building, 'Complete']] }

          it 'changes the state of the spreadsheet_import to failed' do
            spreadsheet_import.reload
            expect(spreadsheet_import.failed?).to be true
          end

          it 'makes the building invalid and has the correct error' do
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:valid]).to be false
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:errors][:other_building_type].first[:error]).to eq :blank
          end
        end

        context 'when the building_type is other and other is more than 150 characters' do
          let(:spreadsheet_building) { create(:facilities_management_building, building_type: 'Other', other_building_type: 'a' * 151) }
          let(:building_data) { [[spreadsheet_building, 'Complete']] }

          it 'changes the state of the spreadsheet_import to failed' do
            spreadsheet_import.reload
            expect(spreadsheet_import.failed?).to be true
          end

          it 'makes the building invalid and has the correct error' do
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:valid]).to be false
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:errors][:other_building_type].first[:error]).to eq :too_long
          end
        end

        context 'when validating all the building types' do
          let(:building_data) do
            FacilitiesManagement::Building::BUILDING_TYPES.pluck(:spreadsheet_title).map do |building_type|
              [
                create(:facilities_management_building, building_type:),
                'Complete'
              ]
            end
          end

          it 'changes the state of the spreadsheet_import to succeeded' do
            spreadsheet_import.reload
            expect(spreadsheet_import.succeeded?).to be true
          end

          it 'makes the building valid' do
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array)).to(be_all { |building| building[:valid] })
          end
        end
      end

      describe 'security_type' do
        context 'when the security_type is blank' do
          let(:spreadsheet_building) { create(:facilities_management_building, security_type: nil) }
          let(:building_data) { [[spreadsheet_building, 'Complete']] }

          it 'changes the state of the spreadsheet_import to failed' do
            spreadsheet_import.reload
            expect(spreadsheet_import.failed?).to be true
          end

          it 'makes the building invalid and has the correct error' do
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:valid]).to be false
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:errors][:security_type].first[:error]).to eq :blank
          end
        end

        context 'when the security_type is not in the list' do
          let(:spreadsheet_building) { create(:facilities_management_building, security_type: 'Super Secret') }
          let(:building_data) { [[spreadsheet_building, 'Complete']] }

          it 'changes the state of the spreadsheet_import to failed' do
            spreadsheet_import.reload
            expect(spreadsheet_import.failed?).to be true
          end

          it 'makes the building invalid and has the correct error' do
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:valid]).to be false
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:errors][:security_type].first[:error]).to eq :inclusion
          end
        end

        context 'when the security_type is Other' do
          let(:spreadsheet_building) { create(:facilities_management_building, security_type: 'Other', other_security_type: 'Super Secret') }
          let(:building_data) { [[spreadsheet_building, 'Complete']] }

          it 'changes the state of the spreadsheet_import to succeeded' do
            spreadsheet_import.reload
            expect(spreadsheet_import.succeeded?).to be true
          end

          it 'saves the building type as lower case other' do
            expect(user.buildings.first.security_type).to eq 'other'
          end
        end

        context 'when the security_type is other and other is blank' do
          let(:spreadsheet_building) { create(:facilities_management_building, security_type: 'Other', other_security_type: nil) }
          let(:building_data) { [[spreadsheet_building, 'Complete']] }

          it 'changes the state of the spreadsheet_import to failed' do
            spreadsheet_import.reload
            expect(spreadsheet_import.failed?).to be true
          end

          it 'makes the building invalid and has the correct error' do
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:valid]).to be false
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:errors][:other_security_type].first[:error]).to eq :blank
          end
        end

        context 'when the security_type is other and other is more than 150 characters' do
          let(:spreadsheet_building) { create(:facilities_management_building, security_type: 'Other', other_security_type: 'a' * 151) }
          let(:building_data) { [[spreadsheet_building, 'Complete']] }

          it 'changes the state of the spreadsheet_import to failed' do
            spreadsheet_import.reload
            expect(spreadsheet_import.failed?).to be true
          end

          it 'makes the building invalid and has the correct error' do
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:valid]).to be false
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:errors][:other_security_type].first[:error]).to eq :too_long
          end
        end
      end
    end

    describe 'import with valid data and missing region' do
      let(:user_building) { create(:facilities_management_building, user:) }

      # rubocop:disable RSpec/AnyInstance
      before do
        allow_any_instance_of(Postcode::PostcodeCheckerV2).to receive(:find_region).with(anything).and_return([])
      end
      # rubocop:enable RSpec/AnyInstance

      context 'when the postcodes are the same' do
        let(:spreadsheet_building) { create(:facilities_management_building, address_postcode: user_building.address_postcode, building_name: user_building.building_name) }
        let(:building_data) { [[spreadsheet_building, 'Complete']] }

        it 'changes the state of the spreadsheet_import to succeeded' do
          spreadsheet_import.reload
          expect(spreadsheet_import.succeeded?).to be true
        end

        it 'does not change the region' do
          expect(user.buildings.first.address_region).to eq user_building.address_region
          expect(user.buildings.first.address_region_code).to eq user_building.address_region_code
        end
      end

      context 'when the postcodes are different' do
        let(:spreadsheet_building) { create(:facilities_management_building, address_postcode: 'AB101AA', building_name: user_building.building_name) }
        let(:building_data) { [[spreadsheet_building, 'Complete']] }

        it 'changes the state of the spreadsheet_import to succeeded' do
          spreadsheet_import.reload
          expect(spreadsheet_import.succeeded?).to be true
        end

        it 'does not change the region' do
          expect(user.buildings.first.address_region).to be_nil
          expect(user.buildings.first.address_region_code).to be_nil
        end
      end
    end
  end
  # rubocop:enable RSpec/NestedGroups

  describe '#import_service_matrix' do
    before do
      fake_spreadsheet.add_building_sheet(building_data)
      fake_spreadsheet.add_service_matrix_sheet(service_matrix_data)
      fake_spreadsheet.write

      # Stub out import methods not under test
      allow(spreadsheet_importer).to receive(:check_file).and_return(nil)

      (process_file_order - %i[import_buildings add_procurement_buildings import_service_matrix]).each do |other_process_method|
        allow(spreadsheet_importer).to receive(other_process_method).and_return(nil)
      end

      allow(FacilitiesManagement::RM3830::SpreadsheetImport).to receive(:find_by).and_return(true)
      allow(FacilitiesManagement::RM3830::SpreadsheetImport).to receive(:find_by).with(anything).and_return(true)

      spreadsheet_importer.import_data
    end

    let(:procurement) { create(:facilities_management_rm3830_procurement) }
    let(:name1) { 'Trumpy Towers' }
    let(:name2) { 'Higginbottom Hall' }
    let(:building1) { create(:facilities_management_building, building_name: name1) }
    let(:building2) { create(:facilities_management_building, building_name: name2) }

    let(:service_matrix_data) do
      [
        { status: status, building_name: name1, services: service_data1 },
        { status: status, building_name: name2, services: service_data2 }
      ]
    end

    let(:building_data) do
      [
        [building1, 'Complete'],
        [building2, 'Complete']
      ]
    end

    context 'when the service matrix data has been filled in correctly (with Yes as the only valid input)' do
      let(:service_data1) { %w[C.1a C.2b C.12a] }
      let(:service_data2) { %w[C.12a C.13c] }
      let(:status) { 'OK' }

      context 'when the data is not already on the system' do
        it 'stores the services' do
          service_codes1 = spreadsheet_importer.instance_variable_get(:@procurement_array).first[:procurement_building][:object].service_codes
          service_codes2 = spreadsheet_importer.instance_variable_get(:@procurement_array).last[:procurement_building][:object].service_codes
          expect(service_codes1).to eq %w[C.1 C.2 C.12]
          expect(service_codes2).to eq %w[C.12 C.13]
        end

        it 'stores the standards' do
          service_standards1 = spreadsheet_importer.instance_variable_get(:@procurement_array).first[:procurement_building][:procurement_building_services].map { |pbs| pbs[:object].service_standard }
          service_standards2 = spreadsheet_importer.instance_variable_get(:@procurement_array).last[:procurement_building][:procurement_building_services].map { |pbs| pbs[:object].service_standard }
          expect(service_standards1).to eq %w[A B A]
          expect(service_standards2).to eq %w[A C]
        end
      end
    end

    context 'when status indicator cells has a red' do
      let(:service_data1) { %w[C.1a C.2a C.12a] }
      let(:service_data2) { %w[C.12a C.13a] }
      let(:status) { 'all goofed up' }

      it 'changes the state of the spreadsheet_import to failed' do
        spreadsheet_import.reload
        expect(spreadsheet_import.failed?).to be true
      end

      it 'has the correct error' do
        expect(spreadsheet_importer_errors).to include(:service_matrix_incomplete)
      end
    end

    context 'when more than one standard of the same service for a building has been selected' do
      let(:service_data1) { %w[C.1a C.1b C.12a] }
      let(:service_data2) { %w[C.12a] }
      let(:status) { 'OK' }

      it 'changes the state of the spreadsheet_import to failed and has the correct import_errors' do
        spreadsheet_import.reload
        expect(spreadsheet_import.failed?).to be true
        expect(spreadsheet_import.service_matrix_errors.first.values).to eq ['Trumpy Towers', :service_codes, [:multiple_standards_for_one_service]]
      end

      it 'has the correct error' do
        expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:procurement_building][:errors]).to eq(service_codes: [{ error: :multiple_standards_for_one_service }])
      end
    end
  end

  describe '#import_service_volumes' do
    before do
      fake_spreadsheet.add_building_sheet(building_data)
      fake_spreadsheet.add_service_matrix_sheet(service_matrix_data)
      fake_spreadsheet.add_service_volumes_1(service_volumes_data)
      fake_spreadsheet.write

      # Stub out import methods not under test
      allow(spreadsheet_importer).to receive(:check_file).and_return(nil)

      (process_file_order - %i[import_buildings add_procurement_buildings import_service_matrix import_service_volumes validate_procurement_building_services]).each do |other_process_method|
        allow(spreadsheet_importer).to receive(other_process_method).and_return(nil)
      end

      allow(FacilitiesManagement::RM3830::SpreadsheetImport).to receive(:find_by).and_return(true)
      allow(FacilitiesManagement::RM3830::SpreadsheetImport).to receive(:find_by).with(anything).and_return(true)

      spreadsheet_importer.import_data
    end

    let(:procurement) { create(:facilities_management_rm3830_procurement) }
    let(:name1) { 'Wollaton Hall' }
    let(:name2) { 'Wayne Manor' }
    let(:building1) { create(:facilities_management_building, building_name: name1) }
    let(:building2) { create(:facilities_management_building, building_name: name2) }

    let(:building_data) { [[building1, 'Complete'], [building2, 'Complete']] }

    let(:service_matrix_data) do
      [
        { status: 'OK', building_name: name1, services: service_data1 },
        { status: 'OK', building_name: name2, services: service_data2 }
      ]
    end

    let(:service_volumes_data) do
      [
        [building1.building_name, service_details1, status1],
        [building2.building_name, service_details2, status2]
      ]
    end

    describe 'import with valid data' do
      context 'when there is one building' do
        let(:building_data) { [[building1, 'Complete']] }

        let(:service_matrix_data) do
          [
            { status: 'OK', building_name: name1, services: service_data1 },
          ]
        end

        let(:service_volumes_data) do
          [
            [building1.building_name, { 'E.4': 4, 'K.1': 20, 'K.3': 8, 'K.6': 69, 'K.7': 12 }, 'OK']
          ]
        end

        let(:service_data1) { %w[E.4 K.1 K.3 K.6 K.7] }

        it 'assigns the service volumes and codes to the building' do
          expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:procurement_building][:procurement_building_services].map { |pbs| [pbs[:object].code.to_sym, pbs[:object].uval] }.sort.to_h).to eq(service_volumes_data.first[1])
        end
      end

      context 'when there is more than one building with the same service codes and volumes' do
        let(:service_details1) { { 'E.4': 4, 'K.1': 20, 'K.3': 8, 'K.6': 69, 'K.7': 12 } }
        let(:service_details2) { service_details1 }
        let(:service_data1) { %w[E.4 K.1 K.3 K.6 K.7] }
        let(:service_data2) { service_data1 }
        let(:status1) { 'OK' }
        let(:status2) { status1 }

        it 'changes the state of the spreadsheet_import to succeeded' do
          spreadsheet_import.reload
          expect(spreadsheet_import.succeeded?).to be true
        end

        it 'assigns the service volumes and codes to the buildings' do
          expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:procurement_building][:procurement_building_services].map { |pbs| [pbs[:object].code.to_sym, pbs[:object].uval] }.sort.to_h).to eq(service_volumes_data.first[1])
        end
      end

      context 'when there is more than one building with different service codes and volumes' do
        let(:service_details1) { { 'E.4': 4, 'K.1': 20, 'K.3': 8, 'K.6': 69, 'K.7': 12 } }
        let(:service_details2) { { 'E.4': 27, 'G.1': 8, 'K.2': 95, 'K.4': 19, 'K.5': 94 } }
        let(:service_data1) { %w[E.4 K.1 K.3 K.6 K.7] }
        let(:service_data2) { %w[E.4 G.1 K.2 K.4 K.5] }
        let(:status1) { 'OK' }
        let(:status2) { status1 }

        it 'changes the state of the spreadsheet_import to succeeded' do
          spreadsheet_import.reload
          expect(spreadsheet_import.succeeded?).to be true
        end

        it 'assigns the service volumes and codes to the buildings' do
          expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:procurement_building][:procurement_building_services].map { |pbs| [pbs[:object].code.to_sym, pbs[:object].uval] }.sort.to_h).to eq(service_volumes_data.first[1])
        end
      end
    end

    describe 'with invalid import data' do
      context 'when importing service hours which are not ready' do
        let(:service_details1) { { 'E.4': 4, 'K.1': 20, 'K.3': 8, 'K.6': 69, 'K.7': 12 } }
        let(:service_details2) { { 'E.4': 27, 'G.1': nil, 'K.2': 95, 'K.4': 19, 'K.5': nil } }
        let(:service_data1) { %w[E.4 K.1 K.3 K.6 K.7] }
        let(:service_data2) { %w[E.4 G.1 K.2 K.4 K.5] }
        let(:status1) { 'OK' }
        let(:status2) { 'Input(s) required for this building (see yellow cells below)' }

        it 'changes the state of the spreadsheet_import to failed and has the correct error' do
          spreadsheet_import.reload

          expect(spreadsheet_import.failed?).to be true
          expect(spreadsheet_importer_errors).to include(:volumes_incomplete)
        end
      end

      context 'when importing one building with missing volumes' do
        let(:building_data) { [[building1, 'Complete']] }

        let(:service_matrix_data) do
          [
            { status: 'OK', building_name: name1, services: %w[E.4 K.1 K.3 K.6 K.7] }
          ]
        end

        let(:service_volumes_data) do
          [
            [building1.building_name, { 'E.4': 17, 'K.1': nil, 'K.3': 8, 'K.6': nil, 'K.7': 20 }, 'OK']
          ]
        end

        it 'changes the state of the spreadsheet_import to failed and has the correct import_errors' do
          spreadsheet_import.reload
          expect(spreadsheet_import.failed?).to be true

          error_details = spreadsheet_import.service_volume_errors
          expect(error_details[0].values).to eq ['Wollaton Hall', 'Classified waste', :no_of_consoles_to_be_serviced, [:blank]]
          expect(error_details[1].values).to eq ['Wollaton Hall', 'Medical waste', :tones_to_be_collected_and_removed, [:blank]]
        end

        it 'only makes K.1 and K.6 invalid and they have the correct errors' do
          validations = spreadsheet_importer.instance_variable_get(:@procurement_array).first[:procurement_building][:procurement_building_services].to_h { |pbs| [pbs[:object].code, pbs[:valid]] }.sort
          expect(validations).to eq([['E.4', true], ['K.1', false], ['K.3', true], ['K.6', false], ['K.7', true]])

          k1_errors = spreadsheet_importer.instance_variable_get(:@procurement_array).first[:procurement_building][:procurement_building_services].select { |pbs| pbs[:object].code == 'K.1' }.first[:errors][:no_of_consoles_to_be_serviced].pluck(:error)
          k6_errors = spreadsheet_importer.instance_variable_get(:@procurement_array).first[:procurement_building][:procurement_building_services].select { |pbs| pbs[:object].code == 'K.6' }.first[:errors][:tones_to_be_collected_and_removed].pluck(:error)
          expect(k1_errors).to include(:blank)
          expect(k6_errors).to include(:blank)
        end
      end

      context 'when importing one building with a volume as a string' do
        let(:building_data) { [[building1, 'Complete']] }

        let(:service_matrix_data) do
          [
            { status: 'OK', building_name: name1, services: %w[E.4 K.1 K.3] }
          ]
        end

        let(:service_volumes_data) do
          [
            [building1.building_name, { 'E.4': 'Hello', 'K.1': 59, 'K.3': 8 }, 'OK']
          ]
        end

        it 'changes the state of the spreadsheet_import to failed and has the correct import_errors' do
          spreadsheet_import.reload

          expect(spreadsheet_import.failed?).to be true
          expect(spreadsheet_import.service_volume_errors.first.values).to eq ['Wollaton Hall', 'Portable appliance testing', :no_of_appliances_for_testing, [:invalid]]
        end

        it 'only makes E.4 invalid and has the correct error' do
          validations = spreadsheet_importer.instance_variable_get(:@procurement_array).first[:procurement_building][:procurement_building_services].to_h { |pbs| [pbs[:object].code, pbs[:valid]] }.sort
          expect(validations).to eq([['E.4', false], ['K.1', true], ['K.3', true]])

          e4_errors = spreadsheet_importer.instance_variable_get(:@procurement_array).first[:procurement_building][:procurement_building_services].select { |pbs| pbs[:object].code == 'E.4' }.first[:errors][:no_of_appliances_for_testing].pluck(:error)
          expect(e4_errors).to include(:not_a_number)
        end
      end

      context 'when importing one building with volumes to large' do
        let(:building_data) { [[building1, 'Complete']] }

        let(:service_matrix_data) do
          [
            { status: 'OK', building_name: name1, services: %w[E.4 K.1 K.3 K.6 K.7] }
          ]
        end

        let(:service_volumes_data) do
          [
            [building1.building_name, { 'E.4': 17, 'K.1': 1000000000, 'K.3': 8, 'K.6': 78, 'K.7': 20 }, 'OK']
          ]
        end

        it 'changes the state of the spreadsheet_import to failed and has the correct import_errors' do
          spreadsheet_import.reload

          expect(spreadsheet_import.failed?).to be true
          expect(spreadsheet_import.service_volume_errors.first.values).to eq ['Wollaton Hall', 'Classified waste', :no_of_consoles_to_be_serviced, [:invalid]]
        end

        it 'only makes K.1 invalid and has the correct error' do
          validations = spreadsheet_importer.instance_variable_get(:@procurement_array).first[:procurement_building][:procurement_building_services].to_h { |pbs| [pbs[:object].code, pbs[:valid]] }.sort
          expect(validations).to eq([['E.4', true], ['K.1', false], ['K.3', true], ['K.6', true], ['K.7', true]])

          k1_errors = spreadsheet_importer.instance_variable_get(:@procurement_array).first[:procurement_building][:procurement_building_services].select { |pbs| pbs[:object].code == 'K.1' }.first[:errors][:no_of_consoles_to_be_serviced].pluck(:error)
          expect(k1_errors).to include(:less_than_or_equal_to)
        end
      end

      context 'when there are more than one building with the same volumes and some missing service codes' do
        let(:service_details1) { { 'E.4': 4, 'K.1': 20, 'K.3': 8, 'K.6': 69, 'K.7': 12 } }
        let(:service_details2) { { 'E.4': nil, 'K.1': nil, 'K.3': 8, 'K.6': nil, 'K.7': 12 } }
        let(:service_data1) { %w[E.4 K.1 K.3 K.6 K.7] }
        let(:service_data2) { service_data1 }
        let(:status1) { 'OK' }
        let(:status2) { status1 }

        it 'changes the state of the spreadsheet_import to failed' do
          spreadsheet_import.reload
          expect(spreadsheet_import.failed?).to be true
        end

        it 'only makes the second building invalid' do
          expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:procurement_building][:procurement_building_services].all? { |pbs| pbs[:valid] }).to be true
          expect(spreadsheet_importer.instance_variable_get(:@procurement_array).last[:procurement_building][:procurement_building_services].all? { |pbs| pbs[:valid] }).to be false
        end
      end
    end
  end

  describe '#import_service_volumes_lifts' do
    before do
      fake_spreadsheet.add_building_sheet(building_data)
      fake_spreadsheet.add_service_matrix_sheet(service_matrix_data)
      fake_spreadsheet.add_service_volumes_2(service_details)
      fake_spreadsheet.write

      # Stub out import methods not under test
      allow(spreadsheet_importer).to receive(:check_file).and_return(nil)

      (process_file_order - %i[import_buildings add_procurement_buildings import_service_matrix import_lift_data validate_procurement_building_services]).each do |other_process_method|
        allow(spreadsheet_importer).to receive(other_process_method).and_return(nil)
      end

      allow(FacilitiesManagement::RM3830::SpreadsheetImport).to receive(:find_by).and_return(true)
      allow(FacilitiesManagement::RM3830::SpreadsheetImport).to receive(:find_by).with(anything).and_return(true)

      spreadsheet_importer.import_data
    end

    let(:procurement) { create(:facilities_management_rm3830_procurement) }
    let(:name1) { 'Wollaton Hall' }
    let(:building1) { create(:facilities_management_building, building_name: name1) }
    let(:building_data) { [[building1, 'Complete']] }

    let(:service_matrix_data) do
      [
        { status: 'OK', building_name: name1, services: service_data }
      ]
    end

    let(:service_details) do
      [
        [building1.building_name, service_detail, status]
      ]
    end

    let(:service_data) { %w[C.5a] }

    describe 'with valid data' do
      context 'when importing lifts for one building' do
        let(:status) { 'OK' }
        let(:service_detail) { [1, 2, 3, 4, 5] }

        it 'changes the state of the spreadsheet_import to succeeded' do
          spreadsheet_import.reload
          expect(spreadsheet_import.succeeded?).to be true
        end

        it 'assigns the lift data to the building' do
          expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:procurement_building][:procurement_building_services].first[:object].lift_data).to eq(service_details.first[1])
        end
      end

      context 'when importing the same number of lifts for two buildings' do
        let(:name2) { 'Wayne Manor' }
        let(:building2) { create(:facilities_management_building, building_name: name2) }
        let(:building_data) { [[building1, 'Complete'], [building2, 'Complete']] }

        let(:service_matrix_data) do
          [
            { status: 'OK', building_name: name1, services: service_data },
            { status: 'OK', building_name: name2, services: service_data }
          ]
        end

        let(:service_details) do
          [
            [building1.building_name, [1, 2, 3, 4, 5], 'OK'],
            [building2.building_name, [1, 2, 3, 4, 5], 'OK']
          ]
        end

        let(:status) { 'OK' }
        let(:service_data1) { %w[C.5a] }

        it 'changes the state of the spreadsheet_import to succeeded' do
          spreadsheet_import.reload
          expect(spreadsheet_import.succeeded?).to be true
        end

        it 'assigns the lift data to the building' do
          expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:procurement_building][:procurement_building_services].first[:object].lift_data).to eq(service_details.first[1])
        end
      end

      context 'when importing different numbers of lifts for two buildings' do
        let(:name2) { 'Wayne Manor' }
        let(:building2) { create(:facilities_management_building, building_name: name2) }
        let(:building_data) { [[building1, 'Complete'], [building2, 'Complete']] }

        let(:service_matrix_data) do
          [
            { status: 'OK', building_name: name1, services: service_data },
            { status: 'OK', building_name: name2, services: service_data }
          ]
        end

        let(:service_details) do
          [
            [building1.building_name, [1, 2, 3, 4, 5], 'OK'],
            [building2.building_name, [1, 5, 8, 12, 3], 'OK']
          ]
        end

        it 'changes the state of the spreadsheet_import to succeeded' do
          spreadsheet_import.reload
          expect(spreadsheet_import.succeeded?).to be true
        end

        it 'assigns the lift data to the building' do
          expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:procurement_building][:procurement_building_services].first[:object].lift_data).to eq(service_details.first[1])
          expect(spreadsheet_importer.instance_variable_get(:@procurement_array).last[:procurement_building][:procurement_building_services].first[:object].lift_data).to eq(service_details.last[1])
        end
      end
    end

    describe 'with invalid data' do
      context 'when importing incomplete lifts' do
        let(:status) { 'Too many values input (see red cells below)' }
        let(:service_detail) { %w[1 2 3] }

        it 'changes the state of the spreadsheet_import to failed' do
          spreadsheet_import.reload
          expect(spreadsheet_import.failed?).to be true
        end

        it 'has the correct error' do
          expect(spreadsheet_importer_errors).to include(:lifts_incomplete)
        end
      end

      context 'when importing lifts which include a string value' do
        let(:status) { 'OK' }
        let(:service_detail) { %w[1 Two 3] }

        it 'changes the state of the spreadsheet_import to failed and has the correct import_errors' do
          spreadsheet_import.reload
          expect(spreadsheet_import.failed?).to be true
          expect(spreadsheet_import.lift_errors.first.values).to eq ['Wollaton Hall', 'Lifts, hoists & conveyance systems maintenance', :number_of_floors]
        end

        it 'is invalid and has the correct error' do
          expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:procurement_building][:procurement_building_services].first[:valid]).to be false

          error = spreadsheet_importer.instance_variable_get(:@procurement_array).first[:procurement_building][:procurement_building_services].first[:errors][:'lifts[1].number_of_floors'].first[:error]
          expect(error).to eq :not_a_number
        end
      end

      context 'when importing lifts which include a 0 value' do
        let(:status) { 'OK' }
        let(:service_detail) { %w[0 2 3] }

        it 'changes the state of the spreadsheet_import to failed and has the correct import_errors' do
          spreadsheet_import.reload
          expect(spreadsheet_import.failed?).to be true
          expect(spreadsheet_import.lift_errors.first.values).to eq ['Wollaton Hall', 'Lifts, hoists & conveyance systems maintenance', :number_of_floors]
        end

        it 'is invalid and has the correct error' do
          expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:procurement_building][:procurement_building_services].first[:valid]).to be false

          error = spreadsheet_importer.instance_variable_get(:@procurement_array).first[:procurement_building][:procurement_building_services].first[:errors][:'lifts[0].number_of_floors'].first[:error]
          expect(error).to eq :greater_than
        end
      end

      context 'when importing lifts which include a nil value' do
        let(:status) { 'OK' }
        let(:service_detail) { ['1', '2', '', '4'] }

        it 'changes the state of the spreadsheet_import to failed and has the correct import_errors' do
          spreadsheet_import.reload
          expect(spreadsheet_import.failed?).to be true
          expect(spreadsheet_import.lift_errors.first.values).to eq ['Wollaton Hall', 'Lifts, hoists & conveyance systems maintenance', :lifts]
        end

        it 'is invalid and has the correct error' do
          expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:procurement_building][:procurement_building_services].first[:valid]).to be false

          error = spreadsheet_importer.instance_variable_get(:@procurement_array).first[:procurement_building][:procurement_building_services].first[:errors][:lifts].first[:error]
          expect(error).to eq :required
        end
      end

      context 'when importing lifts which include a value of 1000' do
        let(:status) { 'OK' }
        let(:service_detail) { %w[1 2 3 1000] }

        it 'changes the state of the spreadsheet_import to failed and has the correct import_errors' do
          spreadsheet_import.reload
          expect(spreadsheet_import.failed?).to be true
          expect(spreadsheet_import.lift_errors.first.values).to eq ['Wollaton Hall', 'Lifts, hoists & conveyance systems maintenance', :number_of_floors]
        end

        it 'is invalid has the correct error' do
          expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:procurement_building][:procurement_building_services].first[:valid]).to be false

          error = spreadsheet_importer.instance_variable_get(:@procurement_array).first[:procurement_building][:procurement_building_services].first[:errors][:'lifts[3].number_of_floors'].first[:error]
          expect(error).to eq :less_than
        end
      end
    end
  end

  describe '#import_service_hours' do
    before do
      fake_spreadsheet.add_building_sheet(building_data)
      fake_spreadsheet.add_service_matrix_sheet(service_matrix_data)
      fake_spreadsheet.add_service_hours_sheet(service_hour_data)
      fake_spreadsheet.write

      # Stub out import methods not under test
      allow(spreadsheet_importer).to receive(:check_file).and_return(nil)

      (process_file_order - %i[import_buildings add_procurement_buildings import_service_matrix import_service_hours validate_procurement_building_services]).each do |other_process_method|
        allow(spreadsheet_importer).to receive(other_process_method).and_return(nil)
      end

      allow(FacilitiesManagement::RM3830::SpreadsheetImport).to receive(:find_by).and_return(true)
      allow(FacilitiesManagement::RM3830::SpreadsheetImport).to receive(:find_by).with(anything).and_return(true)

      spreadsheet_importer.import_data
    end

    let(:procurement) { create(:facilities_management_rm3830_procurement) }
    let(:name1) { 'U.A. High' }
    let(:name2) { 'Funeral Parlor' }
    let(:building1) { create(:facilities_management_building, building_name: name1) }
    let(:building2) { create(:facilities_management_building, building_name: name2) }

    let(:service_hour_data) do
      [
        { status: service_hour_status, building_name: name1, service_hours: service_hour_data1, detail_of_requirement: detail_of_requirement_data1 },
        { status: service_hour_status, building_name: name2, service_hours: service_hour_data2, detail_of_requirement: detail_of_requirement_data2 }
      ]
    end

    let(:service_matrix_data) do
      [
        { status: 'OK', building_name: name1, services: service_data1 },
        { status: 'OK', building_name: name2, services: service_data2 }
      ]
    end

    let(:building_data) do
      [
        [building1, 'Complete'],
        [building2, 'Complete']
      ]
    end

    context 'when some of the services are incomplete' do
      let(:service_data1) { %w[H.4 I.1] }
      let(:service_data2) { %w[J.1] }
      let(:service_hour_status) { 'Not yet complete' }
      let(:service_hour_data1) { { 'H.4': nil, 'I.1': nil } }
      let(:service_hour_data2) { { 'J.1': nil } }
      let(:detail_of_requirement_data1) { { 'H.4': nil, 'I.1': nil } }
      let(:detail_of_requirement_data2) { { 'J.1': nil } }

      it 'changes the state of the spreadsheet_import to failed' do
        spreadsheet_import.reload
        expect(spreadsheet_import.failed?).to be true
      end

      it 'has the correct error' do
        expect(spreadsheet_importer_errors).to include(:service_hours_incomplete)
      end
    end

    context 'when the service hours are filled out correctly with multiple building' do
      let(:service_data1) { %w[H.5 I.2] }
      let(:service_data2) { %w[J.2] }
      let(:service_hour_status) { 'OK' }
      let(:service_hour_data1) { { 'H.5': 450, 'I.2': 11 } }
      let(:service_hour_data2) { { 'J.2': 220 } }
      let(:detail_of_requirement_data1) { { 'H.5': 'Who knows', 'I.2': "It can't be possibles" } }
      let(:detail_of_requirement_data2) { { 'J.2': 'Go beyond, Plus Ultra' } }

      it 'changes the state of the spreadsheet_import to succeed' do
        spreadsheet_import.reload
        expect(spreadsheet_import.succeeded?).to be true
      end

      it 'has the correct service_hour data' do
        service_hours = procurement.procurement_building_services.to_h { |pbs| [pbs.code, pbs.service_hours] }
        expect(service_hours['H.5']).to eq 450
        expect(service_hours['I.2']).to eq 11
        expect(service_hours['J.2']).to eq 220
      end

      it 'has the correct detail_of_requirement data' do
        service_hours = procurement.procurement_building_services.to_h { |pbs| [pbs.code, pbs.detail_of_requirement] }
        expect(service_hours['H.5']).to eq 'Who knows'
        expect(service_hours['I.2']).to eq "It can't be possibles"
        expect(service_hours['J.2']).to eq 'Go beyond, Plus Ultra'
      end
    end

    context 'when the service hours are invlaid' do
      let(:service_data1) { %w[H.5 I.2] }
      let(:service_data2) { %w[J.2] }
      let(:service_hour_status) { 'OK' }
      let(:service_hour_data2) { { 'J.2': 220 } }
      let(:detail_of_requirement_data1) { { 'H.5': 'Who knows', 'I.2': "It can't be possibles" } }
      let(:detail_of_requirement_data2) { { 'J.2': 'Go beyond, Plus Ultra' } }

      context 'when the service hours are blank' do
        let(:service_hour_data1) { { 'H.5': nil, 'I.2': 11 } }

        it 'changes the state of the spreadsheet_import to failed and has the correct import_errors' do
          spreadsheet_import.reload
          expect(spreadsheet_import.failed?).to be true
          expect(spreadsheet_import.service_hour_errors[0].values).to eq ['U.A. High', 'Move and space management - internal moves', :service_hours, [:not_a_number]]
        end

        it 'is not valid and has an error' do
          expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:procurement_building][:procurement_building_services].first[:valid]).to be false
          expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:procurement_building][:procurement_building_services].first[:errors][:service_hours].any?).to be true
        end
      end

      context 'when the service hours are not a number' do
        let(:service_hour_data1) { { 'H.5': 'Im not a number', 'I.2': 11 } }

        it 'changes the state of the spreadsheet_import to failed' do
          spreadsheet_import.reload
          expect(spreadsheet_import.failed?).to be true
        end

        it 'is not valid and has an error on service_hours' do
          expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:procurement_building][:procurement_building_services].first[:valid]).to be false
          expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:procurement_building][:procurement_building_services].first[:errors][:service_hours].any?).to be true
        end
      end
    end

    context 'when the detail of requirement is blank' do
      let(:service_data1) { %w[H.5 I.2] }
      let(:service_data2) { %w[J.2] }
      let(:service_hour_status) { 'OK' }
      let(:service_hour_data1) { { 'H.5': 450, 'I.2': 11 } }
      let(:service_hour_data2) { { 'J.2': 220 } }
      let(:detail_of_requirement_data1) { { 'H.5': nil, 'I.2': "It can't be possibles" } }
      let(:detail_of_requirement_data2) { { 'J.2': 'Go beyond, Plus Ultra' } }

      it 'changes the state of the spreadsheet_import to failed' do
        spreadsheet_import.reload
        expect(spreadsheet_import.failed?).to be true
      end

      it 'is not valid and has an error on detail_of_requirement' do
        expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:procurement_building][:procurement_building_services].first[:valid]).to be false
        expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:procurement_building][:procurement_building_services].first[:errors][:detail_of_requirement].any?).to be true
      end
    end
  end

  describe '#import_data' do
    before do
      fake_spreadsheet.add_building_sheet(building_data)
      fake_spreadsheet.add_service_matrix_sheet(service_matrix_data)
      fake_spreadsheet.add_service_volumes_1(service_volumes_data)
      fake_spreadsheet.add_service_volumes_2(lift_data)
      fake_spreadsheet.add_service_hours_sheet(service_hour_data)
      fake_spreadsheet.write

      allow(spreadsheet_importer).to receive(:check_file).and_return(nil)
      allow(FacilitiesManagement::RM3830::SpreadsheetImport).to receive(:find_by).and_return(true)
      allow(FacilitiesManagement::RM3830::SpreadsheetImport).to receive(:find_by).with(anything).and_return(true)

      spreadsheet_importer.import_data
      procurement.reload
    end

    let(:procurement) { create(:facilities_management_rm3830_procurement, user:) }
    let(:user) { create(:user) }

    let(:name1) { 'The TARDIS' }
    let(:name2) { 'Time   Lord   Council' }
    let(:normalised_name2) { 'Time Lord Council' }
    let(:name3) { 'Powell Estate' }
    let(:building1) { create(:facilities_management_building, building_name: name1) }
    let(:building2) { create(:facilities_management_building, building_name: name2) }
    let(:building3) { create(:facilities_management_building, building_name: name3) }

    let(:building_data) do
      [
        [building1, 'Complete'],
        [building2, 'Complete'],
        [building3, 'Complete']
      ]
    end

    let(:service_matrix_data) do
      [
        { status: 'OK', building_name: name1, services: service_data1 },
        { status: 'OK', building_name: name2, services: service_data2 },
        { status: 'OK', building_name: name3, services: service_data3 }
      ]
    end

    let(:service_data1) { %w[C.1b C.6a C.11b C.14b C.17 D.3 E.4 E.7 G.3b H.10 I.3 K.5 L.7] }
    let(:service_data2) { %w[C.5a D.1 D.2 D.3 D.4 D.5 F.5 F.6 K.7 I.1 I.4 M.1 N.1 O.1] }
    let(:service_data3) { %w[C.7c D.3 E.6 F.5 G.5c H.9 I.2 J.5 K.7 L.7 N.1] }

    let(:service_volumes_data) do
      [
        [name1, service_volume_details1, 'OK'],
        [name2, service_volume_details2, 'OK'],
        [name3, service_volume_details3, 'OK']
      ]
    end

    let(:service_volume_details1) { { 'E.4': 4, 'G.3': 11722, 'K.5': 17875222 } }
    let(:service_volume_details2) { { 'K.7': 274113 } }
    let(:service_volume_details3) { { 'K.7': 135 } }

    let(:lift_data) do
      [
        [building1.building_name, lift_details1, 'OK'],
        [building2.building_name, lift_details2, 'OK'],
        [building3.building_name, lift_details3, 'OK']
      ]
    end

    let(:lift_details1) { [] }
    let(:lift_details2) { [1, 5, 8, 12, 3] }
    let(:lift_details3) { [] }

    let(:service_hour_data) do
      [
        { status: 'OK', building_name: name1, service_hours: service_hour_data1, detail_of_requirement: detail_of_requirement_data1 },
        { status: 'OK', building_name: name2, service_hours: service_hour_data2, detail_of_requirement: detail_of_requirement_data2 },
        { status: 'OK', building_name: name3, service_hours: service_hour_data3, detail_of_requirement: detail_of_requirement_data3 }
      ]
    end

    let(:service_hour_data1) { { 'I.3': 365 } }
    let(:service_hour_data2) { { 'I.1': 367, 'I.4': 3400 } }
    let(:service_hour_data3) { { 'I.2': 321, 'J.5': 322222 } }

    let(:detail_of_requirement_data1) { { 'I.3': '2 personnel for hald an hour every day' } }
    let(:detail_of_requirement_data2) { { 'I.1': 'Some odd reasons', 'I.4': 'Banna swirl' } }
    let(:detail_of_requirement_data3) { { 'I.2': 'Go Beyond', 'J.5': 'Plus Ultra!' } }

    def extract_code(code)
      if requires_service_standard?(code)
        code[0..-2]
      else
        code
      end
    end

    def requires_service_standard?(code)
      ['a', 'b', 'c'].include? code[-1]
    end

    def service_standards_array(service_codes)
      service_codes.select { |code| requires_service_standard?(code) }.map { |code| [extract_code(code), code[-1].upcase] }.sort
    end

    context 'when a full spreadsheet with multiple buildings is uploaded' do
      it 'changes the state of the spreadsheet_import to succeeded' do
        spreadsheet_import.reload
        expect(spreadsheet_import.succeeded?).to be true
      end

      it 'saves the building data correctly' do
        acceptable_attributes = %w[building_name description address_line_1 address_line_2 address_town gia external_area building_type other_building_type security_type other_security_type]
        expect(user.buildings.find_by(building_name: name1).attributes.slice(*acceptable_attributes)).to eq building1.attributes.slice(*acceptable_attributes)
        building2_data = building2.attributes.slice(*acceptable_attributes)
        building2_data['building_name'] = normalised_name2
        expect(user.buildings.find_by(building_name: normalised_name2).attributes.slice(*acceptable_attributes)).to eq building2_data
        expect(user.buildings.find_by(building_name: name3).attributes.slice(*acceptable_attributes)).to eq building3.attributes.slice(*acceptable_attributes)
      end

      it 'saves the procurement data correctly' do
        services = [service_data1, service_data2, service_data3].flatten.map { |code| extract_code(code) }

        expect(procurement.service_codes.sort).to eq services.uniq.sort
        expect(procurement.procurement_buildings.count).to eq 3
        expect(procurement.procurement_building_services.count).to eq services.count
      end

      context 'when considering building1' do
        let(:procurement_building) { procurement.procurement_buildings.select { |pb| pb.name == name1 }.first }
        let(:procurement_building_services) { procurement_building.procurement_building_services }

        it 'saves the procurement_buildings data correctly' do
          expect(procurement_building.service_codes.sort).to eq(service_data1.map { |code| extract_code(code) }.sort)
          expect(procurement_building.name).to eq name1
        end

        it 'saves the procurement_building_service standards data correctly' do
          standards = procurement_building_services.select { |pbs| pbs.service_standard.present? }.map { |pbs| [pbs.code, pbs.service_standard] }.sort
          expect(standards).to eq service_standards_array(service_data1)
        end

        it 'saves the procurement_building_service volume data correctly' do
          volumes = procurement_building_services.select(&:requires_volume?).map { |pbs| [pbs.code.to_sym, pbs.uval] }.sort
          expect(volumes).to eq service_volume_details1.sort
        end

        it 'saves the procurement_building_service service hours data correctly' do
          service_hour_services = procurement_building_services.select(&:requires_service_hours?)
          service_hours = service_hour_services.map { |pbs| [pbs.code.to_sym, pbs.service_hours] }.sort
          detail_of_requirements = service_hour_services.map { |pbs| [pbs.code.to_sym, pbs.detail_of_requirement] }.sort

          expect(service_hours).to eq service_hour_data1.sort
          expect(detail_of_requirements).to eq detail_of_requirement_data1.sort
        end
      end

      context 'when considering building2' do
        let(:procurement_building) { procurement.procurement_buildings.select { |pb| pb.name == normalised_name2 }.first }
        let(:procurement_building_services) { procurement_building.procurement_building_services }

        it 'saves the procurement_buildings data correctly' do
          expect(procurement_building.service_codes.sort).to eq(service_data2.map { |code| extract_code(code) }.sort)
          expect(procurement_building.name).to eq normalised_name2
        end

        it 'saves the procurement_building_service standards data correctly' do
          standards = procurement_building_services.select { |pbs| pbs.service_standard.present? }.to_h { |pbs| [pbs.code, pbs.service_standard] }.sort
          expect(standards).to eq service_standards_array(service_data2)
        end

        it 'saves the procurement_building_service volume data correctly' do
          volumes = procurement_building_services.select(&:requires_volume?).map { |pbs| [pbs.code.to_sym, pbs.uval] }.sort
          expect(volumes).to eq service_volume_details2.sort
        end

        it 'saves the procurement_building_service lift data correctly' do
          lifts = procurement_building_services.find_by(code: 'C.5').lift_data
          expect(lifts).to eq lift_details2
        end

        it 'saves the procurement_building_service service hours data correctly' do
          service_hour_services = procurement_building_services.select(&:requires_service_hours?)
          service_hours = service_hour_services.map { |pbs| [pbs.code.to_sym, pbs.service_hours] }.sort
          detail_of_requirements = service_hour_services.map { |pbs| [pbs.code.to_sym, pbs.detail_of_requirement] }.sort

          expect(service_hours).to eq service_hour_data2.sort
          expect(detail_of_requirements).to eq detail_of_requirement_data2.sort
        end
      end

      context 'when considering building3' do
        let(:procurement_building) { procurement.procurement_buildings.select { |pb| pb.name == name3 }.first }
        let(:procurement_building_services) { procurement_building.procurement_building_services }

        it 'saves the procurement_buildings data correctly' do
          expect(procurement_building.service_codes.sort).to eq(service_data3.map { |code| extract_code(code) }.sort)
          expect(procurement_building.name).to eq name3
        end

        it 'saves the procurement_building_service standards data correctly' do
          standards = procurement_building_services.select { |pbs| pbs.service_standard.present? }.map { |pbs| [pbs.code, pbs.service_standard] }.sort
          expect(standards).to eq service_standards_array(service_data3)
        end

        it 'saves the procurement_building_service volume data correctly' do
          volumes = procurement_building_services.select(&:requires_volume?).map { |pbs| [pbs.code.to_sym, pbs.uval] }.sort
          expect(volumes).to eq service_volume_details3.sort
        end

        it 'saves the procurement_building_service service hours data correctly' do
          service_hour_services = procurement_building_services.select(&:requires_service_hours?)
          service_hours = service_hour_services.map { |pbs| [pbs.code.to_sym, pbs.service_hours] }.sort
          detail_of_requirements = service_hour_services.map { |pbs| [pbs.code.to_sym, pbs.detail_of_requirement] }.sort

          expect(service_hours).to eq service_hour_data3.sort
          expect(detail_of_requirements).to eq detail_of_requirement_data3.sort
        end
      end
    end

    context 'when a full spreadsheet with multiple buildings is uploaded with one error' do
      let(:service_hour_data2) { { 'I.1': 0, 'I.4': 3400 } }

      it 'changes the state of the spreadsheet_import to failed' do
        spreadsheet_import.reload
        expect(spreadsheet_import.failed?).to be true
      end

      it 'has the correct import_errors' do
        spreadsheet_import.reload
        expect(spreadsheet_import.service_hour_errors).to eq [{ building_name: normalised_name2, service_name: 'Reception service', attribute: :service_hours, errors: [:greater_than_or_equal_to] }]
      end
    end

    context 'when a spreadsheet is uploaded with gaps' do
      let(:building_data) do
        [
          [building1, 'Complete'],
          empty_building_data,
          [building2, 'Complete'],
          empty_building_data,
          [building3, 'Complete'],
          empty_building_data
        ]
      end

      let(:service_matrix_data) do
        [
          { status: 'OK', building_name: name1, services: service_data1 },
          empty_service_matrix_data,
          { status: 'OK', building_name: name2, services: service_data2 },
          empty_service_matrix_data,
          { status: 'OK', building_name: name3, services: service_data3 },
          empty_service_matrix_data
        ]
      end

      let(:service_volumes_data) do
        [
          [name1, service_volume_details1, 'OK'],
          empty_service_volumes_data,
          [name2, service_volume_details2, 'OK'],
          empty_service_volumes_data,
          [name3, service_volume_details3, 'OK'],
          empty_service_volumes_data
        ]
      end

      let(:lift_data) do
        [
          [building1.building_name, lift_details1, 'OK'],
          empty_lift_data,
          [building2.building_name, lift_details2, 'OK'],
          empty_lift_data,
          [building3.building_name, lift_details3, 'OK'],
          empty_lift_data
        ]
      end

      let(:service_hour_data) do
        [
          { status: 'OK', building_name: name1, service_hours: service_hour_data1, detail_of_requirement: detail_of_requirement_data1 },
          empty_service_hour_data,
          { status: 'OK', building_name: name2, service_hours: service_hour_data2, detail_of_requirement: detail_of_requirement_data2 },
          empty_service_hour_data,
          { status: 'OK', building_name: name3, service_hours: service_hour_data3, detail_of_requirement: detail_of_requirement_data3 },
          empty_service_hour_data
        ]
      end

      let(:empty_building) { create(:facilities_management_building, building_name: '', status: nil, gia: nil, external_area: nil, description: nil, building_type: nil, security_type: nil, address_town: nil, address_line_1: nil, address_line_2: nil, address_region: nil, address_region_code: nil, address_postcode: nil) }
      let(:empty_building_data) { [empty_building, ''] }
      let(:empty_service_matrix_data) { { status: '', building_name: '', services: [] } }
      let(:empty_service_volumes_data) { ['', {}, ''] }
      let(:empty_lift_data) { ['', [], ''] }
      let(:empty_service_hour_data) { { status: '', building_name: '', service_hours: {}, detail_of_requirement: {} } }

      it 'changes the state of the spreadsheet_import to succeeded' do
        spreadsheet_import.reload
        expect(spreadsheet_import.succeeded?).to be true
      end

      it 'imports the correct number of buildings' do
        expect(procurement.procurement_buildings.count).to eq 3
      end
    end
  end

  describe '.spreadsheet_not_present?' do
    before { spreadsheet_import.save }

    let(:spreadsheet_path) { described_class::TEMPLATE_FILE_PATH }
    let(:procurement) { build(:facilities_management_rm3830_procurement_detailed_search) }

    context 'when the spreadsheet_import has been deleted' do
      before { spreadsheet_import.delete }

      it 'returns true' do
        expect(spreadsheet_importer.send(:spreadsheet_not_present?)).to be true
      end
    end

    context 'when the spreadsheet_import has not been deleted' do
      it 'returns false' do
        expect(spreadsheet_importer.send(:spreadsheet_not_present?)).to be false
      end
    end
  end
end
