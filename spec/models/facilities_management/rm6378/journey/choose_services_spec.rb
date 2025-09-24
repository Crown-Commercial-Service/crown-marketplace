require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6378::Journey::ChooseServices do
  let(:choose_services) { described_class.new(service_codes:, region_codes:, annual_contract_value:) }
  let(:service_codes) { %w[E1 E2] }
  let(:region_codes) {  %w[TLC3 TLC4] }
  let(:annual_contract_value) { 123_456 }

  describe 'validations' do
    context 'when no service codes are present' do
      let(:service_codes) { [] }

      it 'is not valid and has the correct error message' do
        expect(choose_services.valid?).to be false
        expect(choose_services.errors[:service_codes].first).to eq 'Select at least one service you need to include in your procurement'
      end
    end

    # rubocop:disable RSpec/NestedGroups
    context 'when validating that not all services are mandatory' do
      context 'when the only code is Q2' do
        let(:service_codes) { %w[Q2] }

        it 'is not valid and has the correct error message' do
          expect(choose_services.valid?).to be false
          expect(choose_services.errors[:service_codes].first).to eq "You must select another service to include 'CAFM system' and/or 'Helpdesk services'"
        end

        context 'when another service is included as well' do
          before { choose_services.service_codes << 'H1' }

          it 'is valid' do
            expect(choose_services.valid?).to be true
          end
        end
      end

      context 'when the only code is R1' do
        let(:service_codes) { %w[R1] }

        it 'is not valid and has the correct error message' do
          expect(choose_services.valid?).to be false
          expect(choose_services.errors[:service_codes].first).to eq "You must select another service to include 'CAFM system' and/or 'Helpdesk services'"
        end

        context 'when another service is included as well' do
          before { choose_services.service_codes << 'J1' }

          it 'is valid' do
            expect(choose_services.valid?).to be true
          end
        end
      end

      context 'when the only codes are Q2 and R1' do
        let(:service_codes) { %w[Q2 R1] }

        it 'is not valid and has the correct error message' do
          expect(choose_services.valid?).to be false
          expect(choose_services.errors[:service_codes].first).to eq "You must select another service to include 'CAFM system' and/or 'Helpdesk services'"
        end

        context 'when another service is included as well' do
          before { choose_services.service_codes << 'L1' }

          it 'is valid' do
            expect(choose_services.valid?).to be true
          end
        end
      end
    end
    # rubocop:enable RSpec/NestedGroups

    context 'when service codes are present' do
      it 'is valid' do
        expect(choose_services.valid?).to be true
      end
    end
  end

  describe '.next_step_class' do
    it 'returns Journey::ChooseLocations' do
      expect(choose_services.next_step_class).to be FacilitiesManagement::RM6378::Journey::ChooseLocations
    end
  end

  describe '.permit_list' do
    it 'returns a list of the permitted attributes' do
      expect(described_class.permit_list).to eq [:annual_contract_value, { service_codes: [], region_codes: [] }]
    end
  end

  describe '.permitted_keys' do
    it 'returns a list of the permitted keys' do
      expect(described_class.permitted_keys).to eq %i[service_codes region_codes annual_contract_value]
    end
  end

  describe '.slug' do
    it 'returns choose-services' do
      expect(choose_services.slug).to eq 'choose-services'
    end
  end

  describe '.template' do
    it 'returns journey/choose_services' do
      expect(choose_services.template).to eq 'journey/choose_services'
    end
  end

  describe '.final?' do
    it 'returns false' do
      expect(choose_services.final?).to be false
    end
  end

  describe '.services_grouped_by_category' do
    let(:result) { choose_services.services_grouped_by_category.map { |category, services| [category, services.length] } }

    # rubocop:disable RSpec/ExampleLength
    it 'services are grouped together as expected' do
      expect(result).to eq(
        [
          ['E', 22],
          ['F', 13],
          ['G', 8],
          ['H', 10],
          ['I', 12],
          ['J', 21],
          ['K', 5],
          ['M', 7],
          ['O', 5],
          ['P', 14],
          ['Q', 1],
          ['R', 1],
          ['S', 8],
          ['T', 1],
          ['U', 2],
          ['V', 1],
          ['W', 1],
          ['X', 1],
          ['Y', 2],
          ['Z', 1]
        ]
      )
    end
    # rubocop:enable RSpec/ExampleLength
  end
end
