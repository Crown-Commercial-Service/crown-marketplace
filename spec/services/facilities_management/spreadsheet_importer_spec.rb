require 'rails_helper'

RSpec.describe FacilitiesManagement::SpreadsheetImporter, type: :service do
  let!(:spreadsheet_import) do
    FacilitiesManagement::SpreadsheetImport.new.tap do |import|
      import.procurement = procurement
      import.spreadsheet_file.attach(io: File.open(uploaded_file), filename: 'test.xlsx')
    end
  end

  describe '#basic_data_validation' do
    subject(:errors) { importer.basic_data_validation }

    let(:importer) { described_class.new(spreadsheet_import) }
    let(:procurement) { build(:facilities_management_procurement_detailed_search) }

    context 'when uploaded file is true to template' do
      let(:uploaded_file) { described_class::TEMPLATE_FILE_PATH }

      it 'no errors' do
        expect(errors).to be_empty
      end
    end

    context 'when uploaded file differs from template' do
      let(:uploaded_file) do
        Rails.root.join('data', 'facilities_management', 'RM3830 Suppliers Details (for Dev & Test).xlsx')
      end

      it 'includes template invalid error' do
        expect(errors).to include(:template_invalid)
      end

      it 'includes not ready error' do
        expect(errors).to include(:not_ready)
      end
    end
  end

  # rubocop:disable RSpec/NestedGroups
  describe '#import_buildings' do
    let(:uploaded_file) { described_class::TEMPLATE_FILE_PATH }
    let(:procurement) { create(:facilities_management_procurement, user: user) }
    let(:user) { create(:user) }

    let(:spreadsheet_building) { create(:facilities_management_building) }
    let(:spreadsheet_building_2) { create(:facilities_management_building) }
    let(:spreadsheet_importer) { described_class.new(spreadsheet_import) }

    let(:spreadsheet_file) { File.new(spreadsheet_path, 'w+') }
    let(:spreadsheet_path) { './tmp/test.xlsx' }

    # rubocop:disable RSpec/AnyInstance
    before do
      allow_any_instance_of(described_class).to receive(:downloaded_spreadsheet).and_return(spreadsheet_file)
      allow(spreadsheet_import).to receive(:spreadsheet_basic_data_validation).and_return(true)
    end
    # rubocop:enable RSpec/AnyInstance

    describe 'import with valid data' do
      before do
        bulk_upload_spreadsheet_builder(spreadsheet_path, [[spreadsheet_building, 'Complete']])
        spreadsheet_importer.import_data
      end

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
      before do
        spreadsheet_building_2.building_name = 'other building'
        bulk_upload_spreadsheet_builder(spreadsheet_path, [])
        spreadsheet_importer.import_data
      end

      it 'changes the state of the spreadsheet_import to failed' do
        spreadsheet_import.reload
        expect(spreadsheet_import.failed?).to be true
      end

      it 'has the correct error' do
        expect(spreadsheet_importer.instance_variable_get(:@errors)).to include(:building_incomplete)
      end
    end

    describe 'import with some buildings not complete' do
      before do
        spreadsheet_building_2.building_name = 'other building'
        bulk_upload_spreadsheet_builder(spreadsheet_path, [[spreadsheet_building, 'Incomplete'], [spreadsheet_building_2, 'Complete']])
        spreadsheet_importer.import_data
      end

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
          before do
            spreadsheet_building.building_name = ''
            bulk_upload_spreadsheet_builder(spreadsheet_path, [[spreadsheet_building, 'Complete']])
            spreadsheet_importer.import_data
          end

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
          before do
            spreadsheet_building.building_name = 'a' * 26
            bulk_upload_spreadsheet_builder(spreadsheet_path, [[spreadsheet_building, 'Complete']])
            spreadsheet_importer.import_data
          end

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
          before do
            bulk_upload_spreadsheet_builder(spreadsheet_path, [[spreadsheet_building, 'Complete'], [spreadsheet_building_2, 'Complete']])
            spreadsheet_importer.import_data
          end

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
          before do
            spreadsheet_building.description = 'a' * 51
            bulk_upload_spreadsheet_builder(spreadsheet_path, [[spreadsheet_building, 'Complete']])
            spreadsheet_importer.import_data
          end

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
          before do
            spreadsheet_building.address_line_1 = ''
            bulk_upload_spreadsheet_builder(spreadsheet_path, [[spreadsheet_building, 'Complete']])
            spreadsheet_importer.import_data
          end

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
          before do
            spreadsheet_building.address_line_1 = 'a' * 101
            bulk_upload_spreadsheet_builder(spreadsheet_path, [[spreadsheet_building, 'Complete']])
            spreadsheet_importer.import_data
          end

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
          before do
            spreadsheet_building.address_town = ''
            bulk_upload_spreadsheet_builder(spreadsheet_path, [[spreadsheet_building, 'Complete']])
            spreadsheet_importer.import_data
          end

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
          before do
            spreadsheet_building.address_town = 'a' * 31
            bulk_upload_spreadsheet_builder(spreadsheet_path, [[spreadsheet_building, 'Complete']])
            spreadsheet_importer.import_data
          end

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
          before do
            spreadsheet_building.address_postcode = ''
            bulk_upload_spreadsheet_builder(spreadsheet_path, [[spreadsheet_building, 'Complete']])
            spreadsheet_importer.import_data
          end

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
          before do
            spreadsheet_building.address_postcode = 'S143 0VV 0VV'
            bulk_upload_spreadsheet_builder(spreadsheet_path, [[spreadsheet_building, 'Complete']])
            spreadsheet_importer.import_data
          end

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
          before do
            spreadsheet_building.gia = ''
            bulk_upload_spreadsheet_builder(spreadsheet_path, [[spreadsheet_building, 'Complete']])
            spreadsheet_importer.import_data
          end

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
          before do
            spreadsheet_building.external_area = ''
            bulk_upload_spreadsheet_builder(spreadsheet_path, [[spreadsheet_building, 'Complete']])
            spreadsheet_importer.import_data
          end

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
          before do
            allow(spreadsheet_building).to receive(:gia).and_return('abc')
            bulk_upload_spreadsheet_builder(spreadsheet_path, [[spreadsheet_building, 'Complete']])
            spreadsheet_importer.import_data
          end

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
          before do
            allow(spreadsheet_building).to receive(:external_area).and_return('def')
            bulk_upload_spreadsheet_builder(spreadsheet_path, [[spreadsheet_building, 'Complete']])
            spreadsheet_importer.import_data
          end

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
          before do
            spreadsheet_building.gia = 0
            spreadsheet_building.external_area = 0
            bulk_upload_spreadsheet_builder(spreadsheet_path, [[spreadsheet_building, 'Complete']])
            spreadsheet_importer.import_data
          end

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
          before do
            spreadsheet_building.building_type = nil
            bulk_upload_spreadsheet_builder(spreadsheet_path, [[spreadsheet_building, 'Complete']])
            spreadsheet_importer.import_data
          end

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
          before do
            spreadsheet_building.building_type = 'House'
            bulk_upload_spreadsheet_builder(spreadsheet_path, [[spreadsheet_building, 'Complete']])
            spreadsheet_importer.import_data
          end

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
          before do
            spreadsheet_building.building_type = 'Other'
            spreadsheet_building.other_building_type = 'Spanish Villa'
            bulk_upload_spreadsheet_builder(spreadsheet_path, [[spreadsheet_building, 'Complete']])
            spreadsheet_importer.import_data
          end

          it 'changes the state of the spreadsheet_import to succeeded' do
            spreadsheet_import.reload
            expect(spreadsheet_import.succeeded?).to be true
          end

          it 'saves the building type as lower case other' do
            expect(user.buildings.first.building_type).to eq 'other'
          end
        end

        context 'when the building_type is other and other is blank' do
          before do
            spreadsheet_building.building_type = 'other'
            spreadsheet_building.other_building_type = nil
            bulk_upload_spreadsheet_builder(spreadsheet_path, [[spreadsheet_building, 'Complete']])
            spreadsheet_importer.import_data
          end

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
          before do
            spreadsheet_building.building_type = 'other'
            spreadsheet_building.other_building_type = 'a' * 151
            bulk_upload_spreadsheet_builder(spreadsheet_path, [[spreadsheet_building, 'Complete']])
            spreadsheet_importer.import_data
          end

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
              before do
                spreadsheet_building.building_type = building_type
                bulk_upload_spreadsheet_builder(spreadsheet_path, [[spreadsheet_building, 'Complete']])
                spreadsheet_importer.import_data
              end

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
          before do
            spreadsheet_building.security_type = nil
            bulk_upload_spreadsheet_builder(spreadsheet_path, [[spreadsheet_building, 'Complete']])
            spreadsheet_importer.import_data
          end

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
          before do
            spreadsheet_building.security_type = 'Super Secret'
            bulk_upload_spreadsheet_builder(spreadsheet_path, [[spreadsheet_building, 'Complete']])
            spreadsheet_importer.import_data
          end

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
          before do
            spreadsheet_building.security_type = 'Other'
            spreadsheet_building.other_security_type = 'Super Secret'
            bulk_upload_spreadsheet_builder(spreadsheet_path, [[spreadsheet_building, 'Complete']])
            spreadsheet_importer.import_data
          end

          it 'changes the state of the spreadsheet_import to succeeded' do
            spreadsheet_import.reload
            expect(spreadsheet_import.succeeded?).to be true
          end

          it 'saves the building type as lower case other' do
            expect(user.buildings.first.security_type).to eq 'other'
          end
        end

        context 'when the security_type is other and other is blank' do
          before do
            spreadsheet_building.security_type = 'other'
            spreadsheet_building.other_security_type = nil
            bulk_upload_spreadsheet_builder(spreadsheet_path, [[spreadsheet_building, 'Complete']])
            spreadsheet_importer.import_data
          end

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
          before do
            spreadsheet_building.security_type = 'other'
            spreadsheet_building.other_security_type = 'a' * 151
            bulk_upload_spreadsheet_builder(spreadsheet_path, [[spreadsheet_building, 'Complete']])
            spreadsheet_importer.import_data
          end

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
      before { allow_any_instance_of(Postcode::PostcodeCheckerV2).to receive(:find_region).with(user_building.address_postcode.delete(' ')).and_return([]) }
      # rubocop:enable RSpec/AnyInstance

      context 'when the postcodes are the same' do
        before do
          spreadsheet_building.address_postcode = user_building.address_postcode
          bulk_upload_spreadsheet_builder(spreadsheet_path, [[spreadsheet_building, 'Complete']])
          spreadsheet_importer.import_data
        end

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
        before do
          spreadsheet_building.address_postcode = 'AB101AA'
          bulk_upload_spreadsheet_builder(spreadsheet_path, [[spreadsheet_building, 'Complete']])
          spreadsheet_importer.import_data
        end

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

  describe '#import_services' do
    pending
  end
end
