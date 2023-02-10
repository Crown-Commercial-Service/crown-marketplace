require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6232::ProcurementBuilding do
  subject(:procurement_building) { build(:facilities_management_rm6232_procurement_building_no_services, procurement: procurement, service_codes: service_codes) }

  let(:procurement) { create(:facilities_management_rm6232_procurement_entering_requirements) }
  let(:service_codes) { [] }

  describe 'validations' do
    context 'when there are no service codes' do
      it 'is not valid and has the correct error message' do
        expect(procurement_building.valid?(:buildings_and_services)).to be false
        expect(procurement_building.errors[:service_codes].first).to eq 'You must select at least one service for this building'
      end
    end

    context 'when the service codes are blank' do
      let(:service_codes) { [''] }

      it 'is not valid and has the correct error message' do
        expect(procurement_building.valid?(:buildings_and_services)).to be false
        expect(procurement_building.errors[:service_codes].first).to eq 'You must select at least one service for this building'
      end
    end

    context 'when validating that both cleaning services are not present' do
      let(:service_codes) { %w[I.1 I.4] }

      context 'when the services are only the two cleaning services' do
        it 'is not valid and has the correct error message' do
          expect(procurement_building.valid?(:buildings_and_services)).to be false
          expect(procurement_building.errors[:service_codes].first).to eq "'Mobile cleaning' and 'Routine cleaning' are the same, but differ by delivery method. Please choose one of these services only"
        end
      end

      context 'when the services are only the two cleaning services plus another service' do
        before { procurement_building.service_codes << 'E.1' }

        it 'is not valid and has the correct error message' do
          expect(procurement_building.valid?(:buildings_and_services)).to be false
          expect(procurement_building.errors[:service_codes].first).to eq "'Mobile cleaning' and 'Routine cleaning' are the same, but differ by delivery method. Please choose one of these services only"
        end
      end
    end

    # rubocop:disable RSpec/NestedGroups
    context 'when validating that not all services are mandatory' do
      context 'when the only code is Q.3' do
        let(:service_codes) { %w[Q.3] }

        it 'is not valid and has the correct error message' do
          expect(procurement_building.valid?(:buildings_and_services)).to be false
          expect(procurement_building.errors[:service_codes].first).to eq "You must select another service to include 'CAFM system', 'Helpdesk services' and/or 'Management of billable works'"
        end

        context 'when another service is included as well' do
          before { procurement_building.service_codes << 'H.1' }

          it 'will be valid' do
            expect(procurement_building.valid?(:buildings_and_services)).to be true
          end
        end
      end

      context 'when the only code is R.1' do
        let(:service_codes) { %w[R.1] }

        it 'is not valid and has the correct error message' do
          expect(procurement_building.valid?(:buildings_and_services)).to be false
          expect(procurement_building.errors[:service_codes].first).to eq "You must select another service to include 'CAFM system', 'Helpdesk services' and/or 'Management of billable works'"
        end

        context 'when another service is included as well' do
          before { procurement_building.service_codes << 'J.1' }

          it 'will be valid' do
            expect(procurement_building.valid?(:buildings_and_services)).to be true
          end
        end
      end

      context 'when the only code is S.1' do
        let(:service_codes) { %w[S.1] }

        it 'is not valid and has the correct error message' do
          expect(procurement_building.valid?(:buildings_and_services)).to be false
          expect(procurement_building.errors[:service_codes].first).to eq "You must select another service to include 'CAFM system', 'Helpdesk services' and/or 'Management of billable works'"
        end

        context 'when another service is included as well' do
          before { procurement_building.service_codes << 'K.1' }

          it 'will be valid' do
            expect(procurement_building.valid?(:buildings_and_services)).to be true
          end
        end
      end

      context 'when the only codes are Q.3 and R.1' do
        let(:service_codes) { %w[Q.3 R.1] }

        it 'is not valid and has the correct error message' do
          expect(procurement_building.valid?(:buildings_and_services)).to be false
          expect(procurement_building.errors[:service_codes].first).to eq "You must select another service to include 'CAFM system', 'Helpdesk services' and/or 'Management of billable works'"
        end

        context 'when another service is included as well' do
          before { procurement_building.service_codes << 'L.1' }

          it 'will be valid' do
            expect(procurement_building.valid?(:buildings_and_services)).to be true
          end
        end
      end

      context 'when the only codes are Q.3 and S.1' do
        let(:service_codes) { %w[Q.3 S.1] }

        it 'is not valid and has the correct error message' do
          expect(procurement_building.valid?(:buildings_and_services)).to be false
          expect(procurement_building.errors[:service_codes].first).to eq "You must select another service to include 'CAFM system', 'Helpdesk services' and/or 'Management of billable works'"
        end

        context 'when another service is included as well' do
          before { procurement_building.service_codes << 'M.1' }

          it 'will be valid' do
            expect(procurement_building.valid?(:buildings_and_services)).to be true
          end
        end
      end

      context 'when the only codes are S.1 and R.1' do
        let(:service_codes) { %w[S.1 R.1] }

        it 'is not valid and has the correct error message' do
          expect(procurement_building.valid?(:buildings_and_services)).to be false
          expect(procurement_building.errors[:service_codes].first).to eq "You must select another service to include 'CAFM system', 'Helpdesk services' and/or 'Management of billable works'"
        end

        context 'when another service is included as well' do
          before { procurement_building.service_codes << 'J.2' }

          it 'will be valid' do
            expect(procurement_building.valid?(:buildings_and_services)).to be true
          end
        end
      end

      context 'when the only codes are Q.3, S.1 and R.1' do
        let(:service_codes) { %w[Q.3 S.1 R.1] }

        it 'is not valid and has the correct error message' do
          expect(procurement_building.valid?(:buildings_and_services)).to be false
          expect(procurement_building.errors[:service_codes].first).to eq "You must select another service to include 'CAFM system', 'Helpdesk services' and/or 'Management of billable works'"
        end

        context 'when another service is included as well' do
          before { procurement_building.service_codes << 'K.2' }

          it 'will be valid' do
            expect(procurement_building.valid?(:buildings_and_services)).to be true
          end
        end
      end
    end
    # rubocop:enable RSpec/NestedGroups

    context 'when the service selection is valid' do
      let(:service_codes) { %w[E.1 I.1 S.1] }

      it 'will be valid' do
        expect(procurement_building.valid?(:buildings_and_services)).to be true
      end
    end
  end

  describe '.service_selection_complete?' do
    context 'when there are no service codes' do
      let(:service_codes) { [] }

      it 'returns false' do
        expect(procurement_building.service_selection_complete?).to be false
      end
    end

    context 'when the selection is invalid' do
      let(:service_codes) { %w[Q.3 R.1 S.1] }

      it 'returns false' do
        expect(procurement_building.service_selection_complete?).to be false
      end
    end

    context 'when the slection is valid' do
      let(:service_codes) { %w[Q.3 R.1 S.1 E.1] }

      it 'returns true' do
        expect(procurement_building.service_selection_complete?).to be true
      end
    end
  end

  describe '.missing_region?' do
    before { procurement_building.building.update(address_region_code: address_region_code, address_region: address_region) }

    let(:result) { procurement_building.missing_region? }

    context 'when the address region code is nil' do
      let(:address_region_code) { nil }

      context 'and the region is nil' do
        let(:address_region) { nil }

        it 'returns true' do
          expect(result).to be true
        end
      end

      context 'and the region is empty' do
        let(:address_region) { '' }

        it 'returns true' do
          expect(result).to be true
        end
      end

      context 'and the region is present' do
        let(:address_region) { 'Essex' }

        it 'returns true' do
          expect(result).to be true
        end
      end
    end

    context 'when the address region code is empty' do
      let(:address_region_code) { '' }

      context 'and the region is nil' do
        let(:address_region) { nil }

        it 'returns true' do
          expect(result).to be true
        end
      end

      context 'and the region is empty' do
        let(:address_region) { '' }

        it 'returns true' do
          expect(result).to be true
        end
      end

      context 'and the region is present' do
        let(:address_region) { 'Essex' }

        it 'returns true' do
          expect(result).to be true
        end
      end
    end

    context 'when the address region code is present' do
      let(:address_region_code) { 'UKH1' }

      context 'and the region is nil' do
        let(:address_region) { nil }

        it 'returns true' do
          expect(result).to be true
        end
      end

      context 'and the region is empty' do
        let(:address_region) { '' }

        it 'returns true' do
          expect(result).to be true
        end
      end

      context 'and the region is present' do
        let(:address_region) { 'Essex' }

        it 'returns false' do
          expect(result).to be false
        end
      end
    end
  end

  describe '.freeze_building_data' do
    let(:frozen_building_attributes) { %w[building_name description address_town address_line_1 address_line_2 address_postcode address_region address_region_code gia external_area building_type other_building_type security_type other_security_type] }

    context 'when there is no data there already' do
      let(:procurement_building) { create(:facilities_management_rm6232_procurement_building, procurement: procurement) }
      let(:building_attributes) { procurement_building.building.attributes.slice(*frozen_building_attributes) }

      it 'updates the frozen data to match the the building attributes' do
        expect { procurement_building.freeze_building_data }.to change(procurement_building, :frozen_building_data).from({}).to(building_attributes)
      end
    end

    context 'when there is data there already' do
      let(:procurement_building) { create(:facilities_management_rm6232_procurement_building_with_frozen_data, procurement: procurement, building: initial_building) }
      let(:initial_building) { create(:facilities_management_building) }
      let(:inital_procurement_building_attributes) { initial_building.attributes.slice(*frozen_building_attributes) }
      let(:building) { create(:facilities_management_building, building_name: 'Yuzuriha', description: 'A brand new description', gia: 106) }
      let(:procurement_building_attributes) { building.attributes.slice(*frozen_building_attributes) }

      before { procurement_building.update(building: building) }

      it 'updates the frozen data to match the changes to the building' do
        expect { procurement_building.freeze_building_data }.to change(procurement_building, :frozen_building_data).from(inital_procurement_building_attributes).to(procurement_building_attributes)
      end
    end
  end

  describe '.get_frozen_attribute' do
    let(:procurement_building) { create(:facilities_management_rm6232_procurement_building_with_frozen_data, procurement: procurement, building: building) }
    let(:building) { create(:facilities_management_building, building_name: 'Yuzuriha', other_building_type: 'Some other building type', other_security_type: 'Some other security type') }
    let(:result) { procurement_building.get_frozen_attribute(attribute) }

    context 'when the attribute is one that is frozen' do
      context 'and the attribute is building_name' do
        let(:attribute) { 'building_name' }

        it 'returns Yuzuriha' do
          expect(result).to eq 'Yuzuriha'
        end
      end

      context 'and the attribute is description' do
        let(:attribute) { 'description' }

        it 'returns non-json description' do
          expect(result).to eq 'non-json description'
        end
      end

      context 'and the attribute is address_town' do
        let(:attribute) { 'address_town' }

        it 'returns Southend-On-Sea' do
          expect(result).to eq 'Southend-On-Sea'
        end
      end

      context 'and the attribute is address_line_1' do
        let(:attribute) { 'address_line_1' }

        it 'returns 17 Sailors road' do
          expect(result).to eq '17 Sailors road'
        end
      end

      context 'and the attribute is address_line_2' do
        let(:attribute) { 'address_line_2' }

        it 'returns Floor 2' do
          expect(result).to eq 'Floor 2'
        end
      end

      context 'and the attribute is address_postcode' do
        let(:attribute) { 'address_postcode' }

        it 'returns SS84 6VF' do
          expect(result).to eq 'SS84 6VF'
        end
      end

      context 'and the attribute is address_region' do
        let(:attribute) { 'address_region' }

        it 'returns Essex' do
          expect(result).to eq 'Essex'
        end
      end

      context 'and the attribute is address_region_code' do
        let(:attribute) { 'address_region_code' }

        it 'returns UKH1' do
          expect(result).to eq 'UKH1'
        end
      end

      context 'and the attribute is gia' do
        let(:attribute) { 'gia' }

        it 'returns 1002' do
          expect(result).to eq 1002
        end
      end

      context 'and the attribute is external_area' do
        let(:attribute) { 'external_area' }

        it 'returns 4596' do
          expect(result).to eq 4596
        end
      end

      context 'and the attribute is building_type' do
        let(:attribute) { 'building_type' }

        it 'returns General office - Customer Facing' do
          expect(result).to eq 'General office - Customer Facing'
        end
      end

      context 'and the attribute is other_building_type' do
        let(:attribute) { 'other_building_type' }

        it 'returns Some other building type' do
          expect(result).to eq 'Some other building type'
        end
      end

      context 'and the attribute is security_type' do
        let(:attribute) { 'security_type' }

        it 'returns Baseline personnel security standard (BPSS)' do
          expect(result).to eq 'Baseline personnel security standard (BPSS)'
        end
      end

      context 'and the attribute is other_security_type' do
        let(:attribute) { 'other_security_type' }

        it 'returns Some other security type' do
          expect(result).to eq 'Some other security type'
        end
      end
    end

    context 'when the attribute is not one that is frozen' do
      let(:attribute) { 'contract_name' }

      it 'returns nil' do
        expect(result).to be_nil
      end
    end
  end
end
