require 'rails_helper'

RSpec.describe FacilitiesManagement::SpreadsheetImporter, type: :service do
  let(:spreadsheet_import) do
    FacilitiesManagement::SpreadsheetImport.new.tap do |import|
      import.procurement = procurement
      import.spreadsheet_file.attach(io: File.open(spreadsheet_path), filename: 'test.xlsx')
    end
  end

  let(:fake_spreadsheet) { SpreadsheetImportHelper::FakeBulkUploadSpreadsheet.new }
  let(:spreadsheet_path) { SpreadsheetImportHelper::FakeBulkUploadSpreadsheet::OUTPUT_PATH }
  let(:spreadsheet_importer) { described_class.new(spreadsheet_import) }

  describe '#basic_data_validation' do
    subject(:errors) { spreadsheet_importer.basic_data_validation }

    let(:procurement) { build(:facilities_management_procurement_detailed_search) }

    describe 'template validation' do
      before { allow(spreadsheet_importer).to receive(:spreadsheet_ready?).and_return(true) }

      context 'when uploaded file is true to template' do
        let(:spreadsheet_path) { described_class::TEMPLATE_FILE_PATH }

        it 'no errors' do
          expect(errors).to be_empty
        end
      end

      context 'when uploaded file differs from template' do
        let(:spreadsheet_path) do
          Rails.root.join('data', 'facilities_management', 'RM3830 Suppliers Details (for Dev & Test).xlsx')
        end

        it 'includes template invalid error' do
          expect(errors).to include(:template_invalid)
        end
      end
    end

    describe 'spreadsheet readiness' do
      before { allow(spreadsheet_importer).to receive(:template_valid?).and_return(true) }

      # Attention: Ensure the template file DOES NOT have 'Ready to upload' in cell B10.
      # v2.5 (used at the time of writing) didn't
      let(:spreadsheet_path) { described_class::TEMPLATE_FILE_PATH }

      it 'includes not ready error' do
        expect(errors).to include(:not_ready)
      end
    end
  end

  # rubocop:disable RSpec/NestedGroups
  describe '#import_buildings' do
    before do
      fake_spreadsheet.add_building_sheet(building_data)
      fake_spreadsheet.write

      allow(spreadsheet_import).to receive(:spreadsheet_basic_data_validation).and_return(true)

      # Stub out import methods not under test
      (described_class::IMPORT_PROCESS_ORDER - [:import_buildings]).each do |other_import_method|
        allow(spreadsheet_importer).to receive(other_import_method).and_return(nil)
      end

      spreadsheet_importer.import_data
    end

    let(:procurement) { create(:facilities_management_procurement, user: user) }
    let(:user) { create(:user) }
    let(:spreadsheet_building) { create(:facilities_management_building) }
    let(:spreadsheet_building_2) { create(:facilities_management_building) }

    describe 'import with valid data' do
      let(:building_data) { [[spreadsheet_building, 'Complete']] }

      it 'will save the data correctly' do
        acceptable_attributes = ['building_name', 'description', 'address_line_1', 'address_town', 'gia', 'external_area', 'building_type', 'other_building_type', 'security_type', 'other_security_type']
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
        expect(spreadsheet_importer.instance_variable_get(:@errors)).to include(:building_incomplete)
      end
    end

    describe 'import with some buildings not complete' do
      let(:building_data) { [[spreadsheet_building, 'Incomplete'], [spreadsheet_building_2, 'Complete']] }

      it 'changes the state of the spreadsheet_import to failed' do
        spreadsheet_import.reload
        expect(spreadsheet_import.failed?).to be true
      end

      it 'has the correct error' do
        expect(spreadsheet_importer.instance_variable_get(:@errors)).to include(:building_incomplete)
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

          it 'makes the building invalid' do
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:valid]).to be false
          end

          it 'has the correct error' do
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:errors][:building_name].first[:error]).to eq :blank
          end
        end

        context 'when the building name is more than the max characters' do
          let(:spreadsheet_building) { create(:facilities_management_building, building_name: 'a' * 26) }
          let(:building_data) { [[spreadsheet_building, 'Complete']] }

          it 'changes the state of the spreadsheet_import to failed' do
            spreadsheet_import.reload
            expect(spreadsheet_import.failed?).to be true
          end

          it 'makes the building invalid' do
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:valid]).to be false
          end

          it 'has the correct error' do
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:errors][:building_name].first[:error]).to eq :too_long
          end
        end

        context 'when the building name is duplicated' do
          let(:building_data) { [[spreadsheet_building, 'Complete'], [spreadsheet_building_2, 'Complete']] }

          it 'changes the state of the spreadsheet_import to failed' do
            spreadsheet_import.reload
            expect(spreadsheet_import.failed?).to be true
          end

          it 'makes the building invalid' do
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).last[:valid]).to be false
          end

          it 'has the correct error' do
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

          it 'makes the building invalid' do
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:valid]).to be false
          end

          it 'has the correct error' do
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

          it 'makes the building invalid' do
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:valid]).to be false
          end

          it 'has the correct error' do
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

          it 'makes the building invalid' do
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:valid]).to be false
          end

          it 'has the correct error' do
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:errors][:address_line_1].first[:error]).to eq :too_long
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

          it 'makes the building invalid' do
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:valid]).to be false
          end

          it 'has the correct error' do
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

          it 'makes the building invalid' do
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:valid]).to be false
          end

          it 'has the correct error' do
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

          it 'makes the building invalid' do
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:valid]).to be false
          end

          it 'has the correct error' do
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

          it 'makes the building invalid' do
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:valid]).to be false
          end

          it 'has the correct error' do
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

          it 'makes the building invalid' do
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:valid]).to be false
          end

          it 'has the correct error' do
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

          it 'makes the building invalid' do
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:valid]).to be false
          end

          it 'has the correct error' do
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:errors][:external_area].first[:error]).to eq :blank
          end
        end

        context 'when the gia is not numeric' do
          let(:spreadsheet_building) do
            create(:facilities_management_building).tap { |b| allow(b).to receive(:gia).and_return('abc') }
          end

          let(:building_data) { [[spreadsheet_building, 'Complete']] }

          it 'changes the state of the spreadsheet_import to failed' do
            spreadsheet_import.reload
            expect(spreadsheet_import.failed?).to be true
          end

          it 'makes the building invalid' do
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:valid]).to be false
          end

          it 'has the correct error' do
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

          it 'makes the building invalid' do
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:valid]).to be false
          end

          it 'has the correct error' do
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:errors][:external_area].first[:error]).to eq :not_a_number
          end
        end

        context 'when the gia and external area are zero' do
          let(:spreadsheet_building) { create(:facilities_management_building, gia: 0, external_area: 0) }
          let(:building_data) { [[spreadsheet_building, 'Complete']] }

          it 'changes the state of the spreadsheet_import to failed' do
            spreadsheet_import.reload
            expect(spreadsheet_import.failed?).to be true
          end

          it 'makes the building invalid' do
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:valid]).to be false
          end

          it 'has the correct error' do
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

          it 'makes the building invalid' do
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:valid]).to be false
          end

          it 'has the correct error' do
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

          it 'makes the building invalid' do
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:valid]).to be false
          end

          it 'has the correct error' do
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:errors][:building_type].first[:error]).to eq :inclusion
          end
        end

        context 'when the building_type is Other' do
          let(:spreadsheet_building) do
            create(:facilities_management_building, building_type: 'Other', other_building_type: 'Spanish Villa')
          end

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
          let(:spreadsheet_building) do
            create(:facilities_management_building, building_type: 'Other', other_building_type: nil)
          end

          let(:building_data) { [[spreadsheet_building, 'Complete']] }

          it 'changes the state of the spreadsheet_import to failed' do
            spreadsheet_import.reload
            expect(spreadsheet_import.failed?).to be true
          end

          it 'makes the building invalid' do
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:valid]).to be false
          end

          it 'has the correct error' do
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:errors][:other_building_type].first[:error]).to eq :blank
          end
        end

        context 'when the building_type is other and other is more than 150 characters' do
          let(:spreadsheet_building) do
            create(:facilities_management_building, building_type: 'Other', other_building_type: 'a' * 151)
          end

          let(:building_data) { [[spreadsheet_building, 'Complete']] }

          it 'changes the state of the spreadsheet_import to failed' do
            spreadsheet_import.reload
            expect(spreadsheet_import.failed?).to be true
          end

          it 'makes the building invalid' do
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:valid]).to be false
          end

          it 'has the correct error' do
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:errors][:other_building_type].first[:error]).to eq :too_long
          end
        end

        context 'when validating all the building types' do
          FacilitiesManagement::Building::SPREADSHEET_BUILDING_TYPES.each do |building_type|
            context "when the building type is #{building_type}" do
              let(:spreadsheet_building) { create(:facilities_management_building, building_type: building_type) }
              let(:building_data) { [[spreadsheet_building, 'Complete']] }

              it 'changes the state of the spreadsheet_import to succeeded' do
                spreadsheet_import.reload
                expect(spreadsheet_import.succeeded?).to be true
              end

              it 'makes the building valid' do
                expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:valid]).to be true
              end
            end
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

          it 'makes the building invalid' do
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:valid]).to be false
          end

          it 'has the correct error' do
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

          it 'makes the building invalid' do
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:valid]).to be false
          end

          it 'has the correct error' do
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:errors][:security_type].first[:error]).to eq :inclusion
          end
        end

        context 'when the security_type is Other' do
          let(:spreadsheet_building) do
            create(:facilities_management_building, security_type: 'Other', other_security_type: 'Super Secret')
          end

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
          let(:spreadsheet_building) do
            create(:facilities_management_building, security_type: 'Other', other_security_type: nil)
          end

          let(:building_data) { [[spreadsheet_building, 'Complete']] }

          it 'changes the state of the spreadsheet_import to failed' do
            spreadsheet_import.reload
            expect(spreadsheet_import.failed?).to be true
          end

          it 'makes the building invalid' do
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:valid]).to be false
          end

          it 'has the correct error' do
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:errors][:other_security_type].first[:error]).to eq :blank
          end
        end

        context 'when the security_type is other and other is more than 150 characters' do
          let(:spreadsheet_building) do
            create(:facilities_management_building, security_type: 'Other', other_security_type: 'a' * 151)
          end

          let(:building_data) { [[spreadsheet_building, 'Complete']] }

          it 'changes the state of the spreadsheet_import to failed' do
            spreadsheet_import.reload
            expect(spreadsheet_import.failed?).to be true
          end

          it 'makes the building invalid' do
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:valid]).to be false
          end

          it 'has the correct error' do
            expect(spreadsheet_importer.instance_variable_get(:@procurement_array).first[:errors][:other_security_type].first[:error]).to eq :too_long
          end
        end
      end
    end

    describe 'import with valid data and missing region' do
      let(:user_building) { create(:facilities_management_building, user: user) }

      # rubocop:disable RSpec/AnyInstance
      before do
        allow_any_instance_of(Postcode::PostcodeCheckerV2).to receive(:find_region)
          .with(user_building.address_postcode.delete(' ')).and_return([])
      end
      # rubocop:enable RSpec/AnyInstance

      context 'when the postcodes are the same' do
        let(:spreadsheet_building) do
          create(:facilities_management_building, address_postcode: user_building.address_postcode)
        end

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
        let(:spreadsheet_building) { create(:facilities_management_building, address_postcode: 'AB101AA') }
        let(:building_data) { [[spreadsheet_building, 'Complete']] }

        it 'changes the state of the spreadsheet_import to succeeded' do
          spreadsheet_import.reload
          expect(spreadsheet_import.succeeded?).to be true
        end

        it 'does not change the region' do
          expect(user.buildings.first.address_region).to eq nil
          expect(user.buildings.first.address_region_code).to eq nil
        end
      end
    end
  end
  # rubocop:enable RSpec/NestedGroups

  describe '#import_service_matrix' do
    before do
      fake_spreadsheet.add_service_matrix_sheet('bobbins')
      fake_spreadsheet.write

      allow(spreadsheet_import).to receive(:spreadsheet_basic_data_validation).and_return(true)

      # Stub out import methods not under test
      (described_class::IMPORT_PROCESS_ORDER - [:import_service_matrix]).each do |other_import_method|
        allow(spreadsheet_importer).to receive(other_import_method).and_return(nil)
      end

      spreadsheet_importer.import_data
    end

    let(:procurement) { create(:facilities_management_procurement) }

    context 'when the service matrix data has been filled in correctly (with Yes as the only valid input)' do
      context 'when the data is not already on the system' do

        # Then the services and standards data should be saved and this can be checked in services & buildings section
        it 'works' do
          expect(true).to eq true
        end
      end

      context 'when the data is already on the system' do

        # Then the information in the spreadsheet should replace all the existing services and standards data
        pending
      end
    end

    context 'when status indicator cells has a red' do

      # Then the data should not be saved
      # the spreadsheet upload should fail
      pending
    end

    context 'when more than one standard of the same service for a building has been selected' do

      # Then the data should not be saved
      # the spreadsheet upload should fail.
      pending
    end
  end
end
