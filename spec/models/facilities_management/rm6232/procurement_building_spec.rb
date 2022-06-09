require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6232::ProcurementBuilding, type: :model do
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
        expect(procurement_building.service_selection_complete?).to eq false
      end
    end

    context 'when the selection is invalid' do
      let(:service_codes) { %w[Q.3 R.1 S.1] }

      it 'returns false' do
        expect(procurement_building.service_selection_complete?).to eq false
      end
    end

    context 'when the slection is valid' do
      let(:service_codes) { %w[Q.3 R.1 S.1 E.1] }

      it 'returns true' do
        expect(procurement_building.service_selection_complete?).to eq true
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
end
