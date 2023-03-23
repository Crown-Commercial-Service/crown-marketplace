require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::Procurements::SpreadsheetImportsHelper do
  describe '.error_message' do
    context 'when considering building errors' do
      let(:model) { :building_errors }

      context 'and considering address_line_1' do
        let(:attribute) { :address_line_1 }

        it 'returns the correct error message for blank' do
          expect(helper.error_message(model, attribute, :blank)).to eq 'The building address line 1 cannot be blank'
        end

        it 'returns the correct error message for too_long' do
          expect(helper.error_message(model, attribute, :too_long)).to eq 'The building address line 1 cannot be more than 100 characters'
        end
      end

      context 'and considering address_line_2' do
        let(:attribute) { :address_line_2 }

        it 'returns the correct error message for blank' do
          expect(helper.error_message(model, attribute, :too_long)).to eq 'The building address line 2 cannot be more than 100 characters'
        end
      end

      context 'and considering address_postcode' do
        let(:attribute) { :address_postcode }

        it 'returns the correct error message for blank' do
          expect(helper.error_message(model, attribute, :blank)).to eq 'The building postcode is not valid. Enter a valid postcode, like AA1 1AA'
        end

        it 'returns the correct error message for invalid' do
          expect(helper.error_message(model, attribute, :invalid)).to eq 'The building postcode is not valid. Enter a valid postcode, like AA1 1AA'
        end

        it 'returns the correct error message for too_short' do
          expect(helper.error_message(model, attribute, :too_short)).to eq 'The building postcode is not valid. Enter a valid postcode, like AA1 1AA'
        end
      end

      context 'and considering address_town' do
        let(:attribute) { :address_town }

        it 'returns the correct error message for blank' do
          expect(helper.error_message(model, attribute, :blank)).to eq 'The building town/city cannot be blank'
        end

        it 'returns the correct error message for too_long' do
          expect(helper.error_message(model, attribute, :too_long)).to eq 'The building town/city cannot be more than 30 characters'
        end
      end

      context 'and considering building_name' do
        let(:attribute) { :building_name }

        it 'returns the correct error message for taken' do
          expect(helper.error_message(model, attribute, :taken)).to eq 'The building name cannot be duplicated'
        end

        it 'returns the correct error message for too_long' do
          expect(helper.error_message(model, attribute, :too_long)).to eq 'The building name cannot be more than 50 characters'
        end
      end

      context 'and considering building_type' do
        let(:attribute) { :building_type }

        it 'returns the correct error message for blank' do
          expect(helper.error_message(model, attribute, :blank)).to eq 'The building type must be from the selection'
        end

        it 'returns the correct error message for inclusion' do
          expect(helper.error_message(model, attribute, :inclusion)).to eq 'The building type must be from the selection'
        end
      end

      context 'and considering description' do
        let(:attribute) { :description }

        it 'returns the correct error message for too_long' do
          expect(helper.error_message(model, attribute, :too_long)).to eq 'The building description cannot be more than 50 characters'
        end
      end

      context 'and considering external_area' do
        let(:attribute) { :external_area }

        it 'returns the correct error message for blank' do
          expect(helper.error_message(model, attribute, :blank)).to eq 'The building external area must be a number between 1 and 999,999,999'
        end

        it 'returns the correct error message for combined_area' do
          expect(helper.error_message(model, attribute, :combined_area)).to eq 'The building external area must be greater than 0, if the gross internal area is 0'
        end

        it 'returns the correct error message for less_than_or_equal_to' do
          expect(helper.error_message(model, attribute, :less_than_or_equal_to)).to eq 'The building external area must be a number between 1 and 999,999,999'
        end

        it 'returns the correct error message for not_a_number' do
          expect(helper.error_message(model, attribute, :not_a_number)).to eq 'The building external area must be a number between 1 and 999,999,999'
        end

        it 'returns the correct error message for not_an_integer' do
          expect(helper.error_message(model, attribute, :not_an_integer)).to eq 'The building external area must be a number between 1 and 999,999,999'
        end

        it 'returns the correct error message for required' do
          expect(helper.error_message(model, attribute, :required)).to eq 'The building external area must be a number between 1 and 999,999,999'
        end

        it 'returns the correct error message for too_long' do
          expect(helper.error_message(model, attribute, :too_long)).to eq 'The building external area must be a number between 1 and 999,999,999'
        end
      end

      context 'and considering gia' do
        let(:attribute) { :gia }

        it 'returns the correct error message for blank' do
          expect(helper.error_message(model, attribute, :blank)).to eq 'The building gross internal area must be a number between 1 and 999,999,999'
        end

        it 'returns the correct error message for combined_area' do
          expect(helper.error_message(model, attribute, :combined_area)).to eq 'The building gross internal area must be greater than 0, if the external area is 0'
        end

        it 'returns the correct error message for less_than_or_equal_to' do
          expect(helper.error_message(model, attribute, :less_than_or_equal_to)).to eq 'The building gross internal area must be a number between 1 and 999,999,999'
        end

        it 'returns the correct error message for not_a_number' do
          expect(helper.error_message(model, attribute, :not_a_number)).to eq 'The building gross internal area must be a number between 1 and 999,999,999'
        end

        it 'returns the correct error message for not_an_integer' do
          expect(helper.error_message(model, attribute, :not_an_integer)).to eq 'The building gross internal area must be a number between 1 and 999,999,999'
        end

        it 'returns the correct error message for required' do
          expect(helper.error_message(model, attribute, :required)).to eq 'The building gross internal area must be a number between 1 and 999,999,999'
        end

        it 'returns the correct error message for too_long' do
          expect(helper.error_message(model, attribute, :too_long)).to eq 'The building gross internal area must be a number between 1 and 999,999,999'
        end
      end

      context 'and considering other_building_type' do
        let(:attribute) { :other_building_type }

        it 'returns the correct error message for blank' do
          expect(helper.error_message(model, attribute, :blank)).to eq 'The building type-other cannot be blank'
        end

        it 'returns the correct error message for too_long' do
          expect(helper.error_message(model, attribute, :too_long)).to eq 'The building type-other cannot be more than 150 characters'
        end
      end

      context 'and considering other_security_type' do
        let(:attribute) { :other_security_type }

        it 'returns the correct error message for blank' do
          expect(helper.error_message(model, attribute, :blank)).to eq 'The building security clearance-other cannot be blank'
        end

        it 'returns the correct error message for too_long' do
          expect(helper.error_message(model, attribute, :too_long)).to eq 'The building security clearance-other cannot be more than 150 characters'
        end
      end

      context 'and considering security_type' do
        let(:attribute) { :security_type }

        it 'returns the correct error message for blank' do
          expect(helper.error_message(model, attribute, :blank)).to eq 'The building security clearance must be from the selection'
        end

        it 'returns the correct error message for inclusion' do
          expect(helper.error_message(model, attribute, :inclusion)).to eq 'The building security clearance must be from the selection'
        end
      end
    end

    context 'when considering lift errors' do
      let(:model) { :lift_errors }

      context 'and considering lifts' do
        let(:attribute) { :lifts }

        it 'returns the correct error message for invalid' do
          expect(helper.error_message(model, attribute, :invalid)).to eq 'There is a problem with your number of lifts or floors'
        end
      end

      context 'and considering number_of_floors' do
        let(:attribute) { :number_of_floors }

        it 'returns the correct error message for invalid' do
          expect(helper.error_message(model, attribute, :invalid)).to eq 'The number of floors must be a number between 1 and 999'
        end
      end
    end

    context 'when considering service hour errors' do
      let(:model) { :service_hour_errors }

      context 'and considering detail_of_requirement' do
        let(:attribute) { :detail_of_requirement }

        it 'returns the correct error message for blank' do
          expect(helper.error_message(model, attribute, :blank)).to eq 'The detail of requirement cannot be blank'
        end

        it 'returns the correct error message for too_long' do
          expect(helper.error_message(model, attribute, :too_long)).to eq 'The detail of requirement cannot be more than 500 characters'
        end
      end

      context 'and considering service_hours' do
        let(:attribute) { :service_hours }

        it 'returns the correct error message for greater_than_or_equal_to' do
          expect(helper.error_message(model, attribute, :greater_than_or_equal_to)).to eq 'The number of hours required must be a number between 1 and 999,999,999'
        end

        it 'returns the correct error message for less_than_or_equal_to' do
          expect(helper.error_message(model, attribute, :less_than_or_equal_to)).to eq 'The number of hours required must be a number between 1 and 999,999,999'
        end

        it 'returns the correct error message for not_a_number' do
          expect(helper.error_message(model, attribute, :not_a_number)).to eq 'The number of hours required must be a number between 1 and 999,999,999'
        end

        it 'returns the correct error message for not_an_integer' do
          expect(helper.error_message(model, attribute, :not_an_integer)).to eq 'The number of hours required must be a number between 1 and 999,999,999'
        end
      end
    end

    context 'when considering service matrix errors' do
      let(:model) { :service_matrix_errors }

      context 'and considering building' do
        let(:attribute) { :building }

        it 'returns the correct error message for external_area_too_small' do
          expect(helper.error_message(model, attribute, :external_area_too_small)).to eq 'The building has service(s) that require an external area greater than 0 sqm'
        end

        it 'returns the correct error message for gia_too_small' do
          expect(helper.error_message(model, attribute, :gia_too_small)).to eq 'The building has service(s) that require a gross internal area greater than 0 sqm'
        end
      end

      context 'and considering service_codes' do
        let(:attribute) { :service_codes }

        it 'returns the correct error message for invalid' do
          expect(helper.error_message(model, attribute, :invalid)).to eq 'The building does not have any services selected'
        end

        it 'returns the correct error message for invalid_billable' do
          expect(helper.error_message(model, attribute, :invalid_billable)).to eq 'CAFM system, Helpdesk and/or Management of billable works cannot be the only selected services within a building'
        end

        it 'returns the correct error message for invalid_cafm' do
          expect(helper.error_message(model, attribute, :invalid_cafm)).to eq 'CAFM system, Helpdesk and/or Management of billable works cannot be the only selected services within a building'
        end

        it 'returns the correct error message for invalid_cafm_billable' do
          expect(helper.error_message(model, attribute, :invalid_cafm_billable)).to eq 'CAFM system, Helpdesk and/or Management of billable works cannot be the only selected services within a building'
        end

        it 'returns the correct error message for invalid_cafm_helpdesk' do
          expect(helper.error_message(model, attribute, :invalid_cafm_helpdesk)).to eq 'CAFM system, Helpdesk and/or Management of billable works cannot be the only selected services within a building'
        end

        it 'returns the correct error message for invalid_cafm_helpdesk_billable' do
          expect(helper.error_message(model, attribute, :invalid_cafm_helpdesk_billable)).to eq 'CAFM system, Helpdesk and/or Management of billable works cannot be the only selected services within a building'
        end

        it 'returns the correct error message for invalid_cleaning' do
          expect(helper.error_message(model, attribute, :invalid_cleaning)).to eq "'Mobile cleaning’ and ‘Routine cleaning’ are the same, but differ by delivery method. Please choose one of these services only"
        end

        it 'returns the correct error message for invalid_helpdesk' do
          expect(helper.error_message(model, attribute, :invalid_helpdesk)).to eq 'CAFM system, Helpdesk and/or Management of billable works cannot be the only selected services within a building'
        end

        it 'returns the correct error message for invalid_helpdesk_billable' do
          expect(helper.error_message(model, attribute, :invalid_helpdesk_billable)).to eq 'CAFM system, Helpdesk and/or Management of billable works cannot be the only selected services within a building'
        end

        it 'returns the correct error message for multiple_standards_for_one_service' do
          expect(helper.error_message(model, attribute, :multiple_standards_for_one_service)).to eq 'The building has multiple service standards selected. Please choose one of these service standards only'
        end
      end
    end

    context 'when considering service volume errors' do
      let(:model) { :service_volume_errors }

      context 'and considering no_of_appliances_for_testing' do
        let(:attribute) { :no_of_appliances_for_testing }

        it 'returns the correct error message for blank' do
          expect(helper.error_message(model, attribute, :blank)).to eq 'The building has service(s) that requires the input of the number of appliances for testing'
        end

        it 'returns the correct error message for invalid' do
          expect(helper.error_message(model, attribute, :invalid)).to eq 'The volume must be a number between 1 and 999,999,999'
        end
      end

      context 'and considering no_of_building_occupants' do
        let(:attribute) { :no_of_building_occupants }

        it 'returns the correct error message for blank' do
          expect(helper.error_message(model, attribute, :blank)).to eq 'The building has service(s) that requires the input of the number of building occupants'
        end

        it 'returns the correct error message for invalid' do
          expect(helper.error_message(model, attribute, :invalid)).to eq 'The volume must be a number between 1 and 999,999,999'
        end
      end

      context 'and considering no_of_consoles_to_be_serviced' do
        let(:attribute) { :no_of_consoles_to_be_serviced }

        it 'returns the correct error message for blank' do
          expect(helper.error_message(model, attribute, :blank)).to eq 'The building has service(s) that requires the input of the number of consoles to be serviced'
        end

        it 'returns the correct error message for invalid' do
          expect(helper.error_message(model, attribute, :invalid)).to eq 'The volume must be a number between 1 and 999,999,999'
        end
      end

      context 'and considering no_of_units_to_be_serviced' do
        let(:attribute) { :no_of_units_to_be_serviced }

        it 'returns the correct error message for blank' do
          expect(helper.error_message(model, attribute, :blank)).to eq 'The building has service(s) that requires the input of the number of units to be serviced'
        end

        it 'returns the correct error message for invalid' do
          expect(helper.error_message(model, attribute, :invalid)).to eq 'The volume must be a number between 1 and 999,999,999'
        end
      end

      context 'and considering tones_to_be_collected_and_removed' do
        let(:attribute) { :tones_to_be_collected_and_removed }

        it 'returns the correct error message for blank' do
          expect(helper.error_message(model, attribute, :blank)).to eq 'The building has service(s) that requires the input of the number of tonnes to be collected and removed'
        end

        it 'returns the correct error message for invalid' do
          expect(helper.error_message(model, attribute, :invalid)).to eq 'The volume must be a number between 1 and 999,999,999'
        end
      end
    end
  end

  describe '.error_count' do
    let(:result) { helper.error_count(error_lists[attribute], attribute) }
    let(:spreadsheet_import) { create(:facilities_management_rm3830_procurement_spreadsheet_import, import_errors: import_errors, procurement: create(:facilities_management_rm3830_procurement, aasm_state: 'detailed_search_bulk_upload', user: create(:user))) }
    let(:import_errors) { { 'Building 1': building_1_errors, 'Building 2': building_2_errors, 'Building 3': building_3_errors } }
    let(:building_1_errors) do
      {
        building_name: 'Building 1',
        building_errors: { building_name: [{ error: :blank }], address_line_1: [{ error: :blank }] },
        procurement_building_errors: { service_codes: [{ error: :invalid_cafm_helpdesk_billable }] },
        procurement_building_services_errors: {
          'H.4': { service_hours: [{ error: :not_a_number }] },
          'E.4': { no_of_appliances_for_testing: [{ error: :blank }] },
          'G.1': { no_of_building_occupants: [{ error: :greater_than }] },
          'K.7': { no_of_units_to_be_serviced: [{ error: :blank }] },
          'K.2': { tones_to_be_collected_and_removed: [{ error: :less_than_or_equal_to }] },
          'K.4': { tones_to_be_collected_and_removed: [{ error: :less_than_or_equal_to }] }
        }
      }
    end
    let(:building_2_errors) do
      {
        building_name: 'Building 2',
        building_errors: {},
        procurement_building_errors: { service_codes: [{ error: :invalid }], building: [{ error: :gia_too_small }] },
        procurement_building_services_errors: {
          'C.5': { 'lifts[1].number_of_floors': [{ error: :greater_than, value: 0, count: 0 }], 'lifts[3].number_of_floors': [{ error: :greater_than, value: 0, count: 0 }] },
          'I.3': { service_hours: [{ error: :less_than_or_equal_to }], detail_of_requirement: [{ error: :blank }] },
          'J.2': { service_hours: [{ error: :greater_than_or_equal_to }], detail_of_requirement: [{ error: :blank }] },
          'G.3': { no_of_building_occupants: [{ error: :blank }] },
          'K.1': { no_of_consoles_to_be_serviced: [{ error: :less_than_or_equal_to }] }
        }
      }
    end
    let(:building_3_errors) do
      {
        building_name: 'Building 3',
        building_errors: { building_type: [{ error: :inclusion }] },
        procurement_building_errors: { service_codes: [{ error: :invalid_cafm_billable }] },
        procurement_building_services_errors: {
          'J.4': { service_hours: [{ error: :greater_than_or_equal_to }], detail_of_requirement: [{ error: :blank }] },
          'K.3': { tones_to_be_collected_and_removed: [{ error: :blank }] },
          'K.5': { tones_to_be_collected_and_removed: [{ error: :less_than_or_equal_to }] },
          'K.6': { tones_to_be_collected_and_removed: [{ error: :blank }] },
          'E.4': { no_of_appliances_for_testing: [{ error: :less_than_or_equal_to }] }
        }
      }
    end
    let(:error_lists) do
      {
        building_errors: spreadsheet_import.building_errors,
        service_matrix_errors: spreadsheet_import.service_matrix_errors,
        service_volume_errors: spreadsheet_import.service_volume_errors,
        lift_errors: spreadsheet_import.lift_errors,
        service_hour_errors: spreadsheet_import.service_hour_errors,
        other_errors: [:other_errors]
      }
    end

    context 'when the attribute is building_errors' do
      let(:attribute) { :building_errors }

      it 'returns the correct count' do
        expect(result).to eq 3
      end
    end

    context 'when the attribute is service_matrix_errors' do
      let(:attribute) { :service_matrix_errors }

      it 'returns the correct count' do
        expect(result).to eq 4
      end
    end

    context 'when the attribute is lift_errors' do
      let(:attribute) { :lift_errors }

      it 'returns the correct count' do
        expect(result).to eq 1
      end
    end

    context 'when the attribute is service_hour_errors' do
      let(:attribute) { :service_hour_errors }

      it 'returns the correct count' do
        expect(result).to eq 7
      end
    end

    context 'when the attribute is service_volume_errors' do
      let(:attribute) { :service_volume_errors }

      it 'returns the correct count' do
        expect(result).to eq 11
      end
    end

    context 'when the attribute is other_errors' do
      let(:attribute) { :other_errors }

      it 'returns the correct count' do
        expect(result).to eq 1
      end
    end
  end
end
