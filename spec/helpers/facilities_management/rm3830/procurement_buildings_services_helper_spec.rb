require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::ProcurementBuildingsServicesHelper do
  let(:procurement_building_service) { create(:facilities_management_rm3830_procurement_building_service, code:, procurement_building:) }
  let(:procurement_building) { create(:facilities_management_rm3830_procurement_building, procurement:) }
  let(:procurement) { create(:facilities_management_rm3830_procurement) }

  describe 'volume_question' do
    let(:result) { helper.volume_question(procurement_building_service) }

    context 'when the service does not require volume' do
      let(:code) { 'C.5' }

      it 'returns nil' do
        expect(result).to be_nil
      end
    end

    context 'when the service does require a volume' do
      context 'and the service code is E.4' do
        let(:code) { 'E.4' }

        it 'returns no_of_appliances_for_testing' do
          expect(result).to eq :no_of_appliances_for_testing
        end
      end

      context 'and the service code is G.1' do
        let(:code) { 'G.1' }

        it 'returns no_of_building_occupants' do
          expect(result).to eq :no_of_building_occupants
        end
      end

      context 'and the service code is K.1' do
        let(:code) { 'K.1' }

        it 'returns no_of_consoles_to_be_serviced' do
          expect(result).to eq :no_of_consoles_to_be_serviced
        end
      end

      context 'and the service code is K.2' do
        let(:code) { 'K.2' }

        it 'returns tones_to_be_collected_and_removed' do
          expect(result).to eq :tones_to_be_collected_and_removed
        end
      end

      context 'and the service is K.7' do
        let(:code) { 'K.7' }

        it 'returns no_of_units_to_be_serviced' do
          expect(result).to eq :no_of_units_to_be_serviced
        end
      end
    end
  end

  describe '#service_standard_type' do
    context 'when the service is G.1 Routine Cleaning' do
      let(:code) { 'G.1' }

      it 'returns cleaning_standards' do
        @building_service = procurement_building_service
        expect(helper.service_standard_type).to eq :cleaning_standards
      end
    end

    context 'when the service is G.3 Mobile Cleaning Services' do
      let(:code) { 'G.3' }

      it 'returns cleaning_standards' do
        @building_service = procurement_building_service
        expect(helper.service_standard_type).to eq :cleaning_standards
      end
    end

    context 'when the service is G.4 Deep (Periodic) Cleaning' do
      let(:code) { 'G.4' }

      it 'returns cleaning_standards' do
        @building_service = procurement_building_service
        expect(helper.service_standard_type).to eq :cleaning_standards
      end
    end

    context 'when the service is G.5 Cleaning of External Areas' do
      let(:code) { 'G.5' }

      it 'returns cleaning_standards' do
        @building_service = procurement_building_service
        expect(helper.service_standard_type).to eq :cleaning_standards
      end
    end

    context 'when the service is C.7 Internal & External Building Fabric Maintenance' do
      let(:code) { 'C.7' }

      it 'returns building_standards' do
        @building_service = procurement_building_service
        expect(helper.service_standard_type).to eq :building_standards
      end
    end

    context 'when the service is C.1 Mechanical and Electrical Engineering Maintenance' do
      let(:code) { 'C.1' }

      it 'returns ppm_standards' do
        @building_service = procurement_building_service
        expect(helper.service_standard_type).to eq :ppm_standards
      end
    end

    context 'when the service is C.2 Ventilation and Air Conditioning System Maintenance' do
      let(:code) { 'C.2' }

      it 'returns ppm_standards' do
        @building_service = procurement_building_service
        expect(helper.service_standard_type).to eq :ppm_standards
      end
    end

    context 'when the service is C.3 Environmental Cleaning Service' do
      let(:code) { 'C.3' }

      it 'returns ppm_standards' do
        @building_service = procurement_building_service
        expect(helper.service_standard_type).to eq :ppm_standards
      end
    end

    context 'when the service is C.4 Fire Detection and Firefighting Systems Maintenance' do
      let(:code) { 'C.4' }

      it 'returns ppm_standards' do
        @building_service = procurement_building_service
        expect(helper.service_standard_type).to eq :ppm_standards
      end
    end

    context 'when the service is C.6 Security, Access and Intruder Systems Maintenance' do
      let(:code) { 'C.6' }

      it 'returns ppm_standards' do
        @building_service = procurement_building_service
        expect(helper.service_standard_type).to eq :ppm_standards
      end
    end

    context 'when the service is C.11 - Building Management System (BMS) Maintenance' do
      let(:code) { 'C.11' }

      it 'returns ppm_standards' do
        @building_service = procurement_building_service
        expect(helper.service_standard_type).to eq :ppm_standards
      end
    end

    context 'when the service is C.12 Standby Power System Maintenance' do
      let(:code) { 'C.12' }

      it 'returns ppm_standards' do
        @building_service = procurement_building_service
        expect(helper.service_standard_type).to eq :ppm_standards
      end
    end

    context 'when the service is C.13 - High Voltage (HV) and Switchgear Maintenance' do
      let(:code) { 'C.13' }

      it 'returns ppm_standards' do
        @building_service = procurement_building_service
        expect(helper.service_standard_type).to eq :ppm_standards
      end
    end

    context 'when the service is C.5 Lifts, Hoists & Conveyance Systems Maintenance' do
      let(:code) { 'C.5' }

      it 'returns ppm_standards' do
        @building_service = procurement_building_service
        expect(helper.service_standard_type).to eq :ppm_standards
      end
    end

    context 'when the service is C.14 - Catering Equipment Maintenance' do
      let(:code) { 'C.14' }

      it 'returns ppm_standards' do
        @building_service = procurement_building_service
        expect(helper.service_standard_type).to eq :ppm_standards
      end
    end
  end

  describe '.sort_by_lifts_created_at' do
    let(:code) { 'C.5' }
    let(:procurement_lift1) { create(:facilities_management_rm3830_lift, created_at: 1.day.ago, procurement_building_service: procurement_building_service) }
    let(:procurement_lift2) { create(:facilities_management_rm3830_lift, created_at: 4.days.ago, procurement_building_service: procurement_building_service) }
    let(:procurement_lift3) { create(:facilities_management_rm3830_lift, created_at: 3.days.ago, procurement_building_service: procurement_building_service) }
    let(:procurement_lift4) { create(:facilities_management_rm3830_lift, created_at: 2.days.ago, procurement_building_service: procurement_building_service) }

    before do
      procurement_lift1
      procurement_lift2
      procurement_lift3
      procurement_lift4
      @building_service = procurement_building_service
    end

    context 'when all the lifts funds have a created_at' do
      it 'sorts all the lifts by created at' do
        expect(helper.sort_by_lifts_created_at).to eq [procurement_lift2, procurement_lift3, procurement_lift4, procurement_lift1]
      end
    end

    context 'when a lift has nil for created_at' do
      let(:procurement_lift2) { create(:facilities_management_rm3830_lift, created_at: nil, procurement_building_service: procurement_building_service) }

      it 'sorts all the lifts with procurement_lift2 at the end' do
        expect(helper.sort_by_lifts_created_at).to eq [procurement_lift3, procurement_lift4, procurement_lift1, procurement_lift2]
      end
    end
  end

  describe '.form_model' do
    let(:building) { procurement_building.building }

    before do
      helper.params[:service_question] = service_question
      @building = building
      @building_service = procurement_building_service
    end

    context 'when the service question is lifts' do
      let(:service_question) { 'lifts' }
      let(:code) { 'C.5' }

      it 'returns the procurement_building_service object' do
        expect(helper.form_model).to eq procurement_building_service
      end
    end

    context 'when the service question is service_standards' do
      let(:service_question) { 'service_standards' }
      let(:code) { 'C.1' }

      it 'returns the procurement_building_service object' do
        expect(helper.form_model).to eq procurement_building_service
      end
    end

    context 'when the service question is volume' do
      let(:service_question) { 'volume' }
      let(:code) { 'K.3' }

      it 'returns the procurement_building_service object' do
        expect(helper.form_model).to eq procurement_building_service
      end
    end

    context 'when the service question is service_hours' do
      let(:service_question) { 'service_hours' }
      let(:code) { 'J.1' }

      it 'returns the procurement_building_service object' do
        expect(helper.form_model).to eq procurement_building_service
      end
    end

    context 'when the service question is area' do
      let(:service_question) { 'area' }
      let(:code) { 'G.1' }

      it 'returns the building object' do
        expect(helper.form_model).to eq building
      end
    end
  end

  describe '.page_heading' do
    let(:building) { procurement_building.building }

    before do
      helper.params[:service_question] = service_question
      @building = building
      @building_service = procurement_building_service
    end

    context 'when the service question is lifts' do
      let(:service_question) { 'lifts' }
      let(:code) { 'C.5' }

      it 'returns the service name' do
        expect(helper.page_heading).to eq procurement_building_service.name
      end
    end

    context 'when the service question is service_standards' do
      let(:service_question) { 'service_standards' }
      let(:code) { 'C.1' }

      it 'returns the service name' do
        expect(helper.page_heading).to eq procurement_building_service.name
      end
    end

    context 'when the service question is volume' do
      let(:service_question) { 'volume' }
      let(:code) { 'K.3' }

      it 'returns the service name' do
        expect(helper.page_heading).to eq procurement_building_service.name
      end
    end

    context 'when the service question is service_hours' do
      let(:service_question) { 'service_hours' }
      let(:code) { 'J.1' }

      it 'returns the service name' do
        expect(helper.page_heading).to eq procurement_building_service.name
      end
    end

    context 'when the service question is area' do
      let(:service_question) { 'area' }
      let(:code) { 'G.1' }

      it 'returns' do
        expect(helper.page_heading).to eq 'Internal and external areas'
      end
    end
  end

  describe '.per_annum_volume?' do
    let(:result) { helper.per_annum_volume?(volume) }

    context 'when the volume is no_of_appliances_for_testing' do
      let(:volume) { :no_of_appliances_for_testing }

      it 'returns true' do
        expect(result).to be true
      end
    end

    context 'when the volume is no_of_building_occupants' do
      let(:volume) { :no_of_building_occupants }

      it 'returns false' do
        expect(result).to be false
      end
    end

    context 'when the volume is no_of_consoles_to_be_serviced' do
      let(:volume) { :no_of_consoles_to_be_serviced }

      it 'returns true' do
        expect(result).to be true
      end
    end

    context 'when the volume is tones_to_be_collected_and_removed' do
      let(:volume) { :tones_to_be_collected_and_removed }

      it 'returns true' do
        expect(result).to be true
      end
    end

    context 'when the volume is no_of_units_to_be_serviced' do
      let(:volume) { :no_of_units_to_be_serviced }

      it 'returns true' do
        expect(result).to be true
      end
    end
  end
end
