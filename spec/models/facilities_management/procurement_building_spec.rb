require 'rails_helper'

RSpec.describe FacilitiesManagement::ProcurementBuilding, type: :model do
  subject(:procurement_building) { build(:facilities_management_procurement_building, procurement: create(:facilities_management_procurement), procurement_building_services: []) }

  describe 'verify active scope works' do
    context 'when not active exclude' do
      it 'is active' do
        procurement_building.active = false
        procurement_building.save
        expect(described_class.active.count).to eq 1
      end
      it 'is not active' do
        procurement_building.active = true
        procurement_building.save
        expect(described_class.active.count).to eq 2
      end
    end
  end

  describe '#validations' do
    context 'when inactive and service_codes empty' do
      it 'is valid' do
        procurement_building.active = false
        procurement_building.service_codes = []
        expect(procurement_building.valid?(:building_services)).to eq true
      end
    end

    context 'when inactive and service_codes not empty' do
      it 'is valid' do
        procurement_building.active = false
        procurement_building.service_codes = ['test']
        expect(procurement_building.valid?(:building_services)).to eq true
      end
    end

    context 'when active and service_codes empty' do
      it 'is invalid' do
        procurement_building.active = true
        procurement_building.service_codes = []
        expect(procurement_building.valid?(:building_services)).to eq false
      end
    end

    context 'when active and service_codes not empty' do
      it 'is valid' do
        procurement_building.active = true
        procurement_building.service_codes = ['test']
        expect(procurement_building.valid?(:building_services)).to eq true
      end
    end
  end

  describe 'update_procurement_building_services' do
    context 'when no procurement_building_services exists' do
      it 'creates a new procurement_building_service' do
        procurement_building.active = true
        procurement_building.service_codes = ['test']
        expect { procurement_building.save }.to change(FacilitiesManagement::ProcurementBuildingService, :count)
      end
    end

    context 'when procurement_building_service already exists' do
      it 'does not create a new one' do
        procurement_building.active = true
        procurement_building.service_codes = ['test']
        procurement_building.save
        procurement_building.service_codes = ['test']
        expect { procurement_building.save }.not_to change(FacilitiesManagement::ProcurementBuildingService, :count)
      end
    end

    context 'when procurement_building_service already exists but for a different service code' do
      it 'creates a new one and deletes the old one' do
        procurement_building.active = true
        procurement_building.service_codes = ['test']
        procurement_building.save
        procurement_building.service_codes = ['test1']
        procurement_building.save
        procurement_building.reload
        expect(procurement_building.procurement_building_services.first.code).to eq 'test1'
        expect(procurement_building.procurement_building_services.count).to eq 1
      end
    end
  end

  describe 'validation for special service choices' do
    before { procurement_building.active = true }

    context 'when the only service code selected is O.1' do
      before { procurement_building.service_codes = ['O.1'] }

      it 'will not be valid' do
        expect(procurement_building.valid?(:building_services)).to be false
      end

      it 'will have the correct error message' do
        procurement_building.valid?(:building_services)
        expect(procurement_building.errors[:service_codes].first).to eq "You must select another service to include 'Management of billable works' to '#{procurement_building.building_name}' building"
      end

      context 'when another service is included as well' do
        before { procurement_building.service_codes << 'C.1' }

        it 'will be valid' do
          expect(procurement_building.valid?(:building_services)).to be true
        end
      end
    end

    context 'when the only service code selected is N.1' do
      before { procurement_building.service_codes = ['N.1'] }

      it 'will not be valid' do
        expect(procurement_building.valid?(:building_services)).to be false
      end

      it 'will have the correct error message' do
        procurement_building.valid?(:building_services)
        expect(procurement_building.errors[:service_codes].first).to eq "You must select another service to include 'Helpdesk services' to '#{procurement_building.building_name}' building"
      end

      context 'when another service is included as well' do
        before { procurement_building.service_codes << 'C.1' }

        it 'will be valid' do
          expect(procurement_building.valid?(:building_services)).to be true
        end
      end
    end

    context 'when the only service code selected is M.1' do
      before { procurement_building.service_codes = ['M.1'] }

      it 'will not be valid' do
        expect(procurement_building.valid?(:building_services)).to be false
      end

      it 'will have the correct error message' do
        procurement_building.valid?(:building_services)
        expect(procurement_building.errors[:service_codes].first).to eq "You must select another service to include 'CAFM system' to '#{procurement_building.building_name}' building"
      end

      context 'when another service is included as well' do
        before { procurement_building.service_codes << 'C.1' }

        it 'will be valid' do
          expect(procurement_building.valid?(:building_services)).to be true
        end
      end
    end

    context 'when the only service codes selected are only O.1 and M.1' do
      before { procurement_building.service_codes = ['O.1', 'M.1'] }

      it 'will not be valid' do
        expect(procurement_building.valid?(:building_services)).to be false
      end

      it 'will have the correct error message' do
        procurement_building.valid?(:building_services)
        expect(procurement_building.errors[:service_codes].first).to eq "You must select another service to include 'CAFM system', 'Management of billable works' to '#{procurement_building.building_name}' building"
      end

      context 'when another service is included as well' do
        before { procurement_building.service_codes << 'C.1' }

        it 'will be valid' do
          expect(procurement_building.valid?(:building_services)).to be true
        end
      end
    end

    context 'when the only service codes selected are only O.1 and N.1' do
      before { procurement_building.service_codes = ['O.1', 'N.1'] }

      it 'will not be valid' do
        expect(procurement_building.valid?(:building_services)).to be false
      end

      it 'will have the correct error message' do
        procurement_building.valid?(:building_services)
        expect(procurement_building.errors[:service_codes].first).to eq "You must select another service to include 'Helpdesk services', 'Management of billable works' to '#{procurement_building.building_name}' building"
      end

      context 'when another service is included as well' do
        before { procurement_building.service_codes << 'C.1' }

        it 'will be valid' do
          expect(procurement_building.valid?(:building_services)).to be true
        end
      end
    end

    context 'when the only service codes selected are only M.1 and N.1' do
      before { procurement_building.service_codes = ['M.1', 'N.1'] }

      it 'will not be valid' do
        expect(procurement_building.valid?(:building_services)).to be false
      end

      it 'will have the correct error message' do
        procurement_building.valid?(:building_services)
        expect(procurement_building.errors[:service_codes].first).to eq "You must select another service to include 'CAFM system', 'Helpdesk services' to '#{procurement_building.building_name}' building"
      end

      context 'when another service is included as well' do
        before { procurement_building.service_codes << 'C.1' }

        it 'will be valid' do
          expect(procurement_building.valid?(:building_services)).to be true
        end
      end
    end

    context 'when the only service codes selected are only O.1, N.1 and M.1' do
      before { procurement_building.service_codes = ['O.1', 'N.1', 'M.1'] }

      it 'will not be valid' do
        expect(procurement_building.valid?(:building_services)).to be false
      end

      it 'will have the correct error message' do
        procurement_building.valid?(:building_services)
        expect(procurement_building.errors[:service_codes].first).to eq "You must select another service to include 'CAFM system', 'Helpdesk services', 'Management of billable works' to '#{procurement_building.building_name}' building"
      end

      context 'when another service is included as well' do
        before { procurement_building.service_codes << 'C.1' }

        it 'will be valid' do
          expect(procurement_building.valid?(:building_services)).to be true
        end
      end
    end

    context 'when the only service codes selected include G.1 and G.3' do
      before { procurement_building.service_codes = ['G.1', 'G.3'] }

      it 'will not be valid' do
        expect(procurement_building.valid?(:building_services)).to be false
      end

      it 'will have the correct error message' do
        procurement_building.valid?(:building_services)
        expect(procurement_building.errors[:service_codes].first).to eq "'Mobile cleaning' and 'Routine cleaning' are the same, but differ by delivery method. Please choose one of these services only for '#{procurement_building.building_name}' building"
      end

      context 'when another service is included as well' do
        before { procurement_building.service_codes << 'C.1' }

        it 'will not be valid' do
          expect(procurement_building.valid?(:building_services)).to be false
        end
      end
    end
  end

  describe 'validation on procurement_building_services_present' do
    context 'when there are no services selected' do
      it 'is not valid' do
        expect(procurement_building.valid?(:procurement_building_services_present)).to be false
      end

      it 'returns the correct error message' do
        procurement_building.valid?(:procurement_building_services_present)

        expect(procurement_building.errors[:service_codes].first).to eq "You must select at least one service for ‘#{procurement_building.building_name}’ building"
      end
    end

    context 'when a service is selected' do
      it 'is valid' do
        procurement_building.service_codes << 'C.1'

        expect(procurement_building.valid?(:procurement_building_services_present)).to be true
      end
    end
  end
end
