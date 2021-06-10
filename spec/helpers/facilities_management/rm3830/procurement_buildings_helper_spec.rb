require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::ProcurementBuildingsHelper, type: :helper do
  describe '.cell_class' do
    let(:context) { nil }
    let(:answer) { nil }
    let(:errors) { false }
    let(:result) { helper.cell_class(context, answer, errors) }

    context 'when there are no errors' do
      it 'returns no extra class' do
        expect(result).to eq 'govuk-table__cell govuk-!-padding-right-2'
      end

      context 'and the context is service_hours but the answer is not present' do
        let(:context) { :service_hours }

        it 'returns no extra class' do
          expect(result).to eq 'govuk-table__cell govuk-!-padding-right-2'
        end
      end

      context 'and the context is service_hours but the answer is present' do
        let(:context) { :service_hours }
        let(:answer) { 150 }

        it 'returns the extra class' do
          expect(result).to eq 'govuk-table__cell govuk-!-padding-right-2 govuk-border-bottom_none'
        end
      end
    end

    context 'when there are errors' do
      let(:errors) { true }

      it 'returns the extra class' do
        expect(result).to eq 'govuk-table__cell govuk-!-padding-right-2 govuk-border-bottom_none'
      end
    end
  end

  describe '.regions' do
    let(:building) { create(:facilities_management_building) }

    before do
      @building = building
      allow(Postcode::PostcodeCheckerV2).to receive(:find_region).and_return([{ "code": 'UKH2', "region": 'Bedfordshire and Hertfordshire' }, { "code": 'UKJ1', "region": 'Berkshire, Buckinghamshire and Oxfordshire' }])
    end

    it 'returns the region names' do
      expect(helper.regions).to eq ['Bedfordshire and Hertfordshire', 'Berkshire, Buckinghamshire and Oxfordshire']
    end
  end

  describe '#get_service_question' do
    context 'when question is service_standard' do
      it 'will return service_standards' do
        result = helper.get_service_question(:service_standard)
        expect(result).to eq 'service_standards'
      end
    end

    context 'when question is lift_data' do
      it 'will return lifts' do
        result = helper.get_service_question(:lift_data)
        expect(result).to eq 'lifts'
      end
    end

    context 'when question is service_hours' do
      it 'will return service_hours' do
        result = helper.get_service_question(:service_hours)
        expect(result).to eq 'service_hours'
      end
    end

    context 'when question is no_of_appliances_for_testing' do
      it 'will return volumes' do
        result = helper.get_service_question(:no_of_appliances_for_testing)
        expect(result).to eq 'volumes'
      end
    end

    context 'when question is no_of_building_occupants' do
      it 'will return volumes' do
        result = helper.get_service_question(:no_of_building_occupants)
        expect(result).to eq 'volumes'
      end
    end

    context 'when question is no_of_consoles_to_be_serviced' do
      it 'will return volumes' do
        result = helper.get_service_question(:no_of_consoles_to_be_serviced)
        expect(result).to eq 'volumes'
      end
    end

    context 'when question is tones_to_be_collected_and_removed' do
      it 'will return volumes' do
        result = helper.get_service_question(:tones_to_be_collected_and_removed)
        expect(result).to eq 'volumes'
      end
    end

    context 'when question is no_of_units_to_be_serviced' do
      it 'will return volumes' do
        result = helper.get_service_question(:no_of_units_to_be_serviced)
        expect(result).to eq 'volumes'
      end
    end

    context 'when question is nil' do
      it 'will return service_standards' do
        result = helper.get_service_question(nil)
        expect(result).to eq 'area'
      end
    end
  end

  describe '#procurement_building_status' do
    let(:procurement_building) { create(:facilities_management_procurement_building, procurement: procurement) }
    let(:procurement) { create(:facilities_management_procurement, user: user) }
    let(:user) { create(:user) }

    before do
      @procurement_building = procurement_building
      allow(procurement_building).to receive(:complete?).and_return(answer)
    end

    context 'when the procurement_building is complete' do
      let(:answer) { true }

      it 'returns the COMPLETE status' do
        expect(helper.procurement_building_status).to eq [:blue, 'COMPLETE']
      end
    end

    context 'when the procurement_building is not complete' do
      let(:answer) { false }

      it 'returns the INCOMPLETE status' do
        expect(helper.procurement_building_status).to eq [:red, 'INCOMPLETE']
      end
    end
  end

  describe '.form_object' do
    let(:procurement_building) { create(:facilities_management_procurement_building, procurement: create(:facilities_management_procurement)) }
    let(:building) { create(:facilities_management_building) }

    before do
      @step = edit_step
      @procurement_building = procurement_building
      @building = building
    end

    context 'when the step is building_and_services' do
      let(:edit_step) { 'building_and_services' }

      it 'returns the procurement building object' do
        expect(helper.form_object).to eq procurement_building
      end
    end

    context 'when the step is missing regions' do
      let(:edit_step) { 'missing_region' }

      it 'returns the building object' do
        expect(helper.form_object).to eq building
      end
    end
  end

  describe '.question_id' do
    let(:procurement_building_service) { create(:facilities_management_procurement_building_service, code: 'K.5', procurement_building: create(:facilities_management_procurement_building, procurement: create(:facilities_management_procurement))) }

    it 'creates the question id' do
      expect(helper.question_id(procurement_building_service, :tones_to_be_collected_and_removed, 'volume')).to eq 'K.5-tones_to_be_collected_and_removed-volume'
    end
  end

  describe 'service_has_errors?' do
    let(:gia) { 56 }
    let(:external_area) { 45 }
    let(:building) { create(:facilities_management_building, gia: gia, external_area: external_area) }
    let(:procurement_building) { create(:facilities_management_procurement_building, service_codes: ['C.1', 'G.5'], building: building, procurement: create(:facilities_management_procurement)) }
    let(:result) { helper.service_has_errors?(context) }

    before { @procurement_building = procurement_building }

    context 'when the context is gia' do
      let(:context) { :gia }

      context 'when the gia has been provided' do
        it 'returns false' do
          expect(result).to eq false
        end
      end

      context 'when the gia has not been provided' do
        let(:gia) { 0 }

        it 'returns true' do
          expect(result).to eq true
        end
      end
    end

    context 'when the context is external_area' do
      let(:context) { :external_area }

      context 'when the external area has been provided' do
        it 'returns false' do
          expect(result).to eq false
        end
      end

      context 'when the external area has not been provided' do
        let(:external_area) { 0 }

        it 'returns true' do
          expect(result).to eq true
        end
      end
    end

    context 'when the context is not gia or external_area' do
      let(:context) { :volume }

      it 'returns false' do
        expect(result).to eq false
      end
    end
  end
end
