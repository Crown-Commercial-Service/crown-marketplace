require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6232::Journey::ChooseServices do
  let(:choose_services) { described_class.new(service_codes:, region_codes:, annual_contract_value:) }
  let(:service_codes) { %w[E.1 E.2] }
  let(:region_codes) {  %w[UKC1 UKC2] }
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
      context 'when the only code is Q.3' do
        let(:service_codes) { %w[Q.3] }

        it 'is not valid and has the correct error message' do
          expect(choose_services.valid?).to be false
          expect(choose_services.errors[:service_codes].first).to eq "You must select another service to include 'CAFM system', 'Helpdesk services' and/or 'Management of billable works'"
        end

        context 'when another service is included as well' do
          before { choose_services.service_codes << 'H.1' }

          it 'is valid' do
            expect(choose_services.valid?).to be true
          end
        end
      end

      context 'when the only code is R.1' do
        let(:service_codes) { %w[R.1] }

        it 'is not valid and has the correct error message' do
          expect(choose_services.valid?).to be false
          expect(choose_services.errors[:service_codes].first).to eq "You must select another service to include 'CAFM system', 'Helpdesk services' and/or 'Management of billable works'"
        end

        context 'when another service is included as well' do
          before { choose_services.service_codes << 'J.1' }

          it 'is valid' do
            expect(choose_services.valid?).to be true
          end
        end
      end

      context 'when the only code is S.1' do
        let(:service_codes) { %w[S.1] }

        it 'is not valid and has the correct error message' do
          expect(choose_services.valid?).to be false
          expect(choose_services.errors[:service_codes].first).to eq "You must select another service to include 'CAFM system', 'Helpdesk services' and/or 'Management of billable works'"
        end

        context 'when another service is included as well' do
          before { choose_services.service_codes << 'K.1' }

          it 'is valid' do
            expect(choose_services.valid?).to be true
          end
        end
      end

      context 'when the only codes are Q.3 and R.1' do
        let(:service_codes) { %w[Q.3 R.1] }

        it 'is not valid and has the correct error message' do
          expect(choose_services.valid?).to be false
          expect(choose_services.errors[:service_codes].first).to eq "You must select another service to include 'CAFM system', 'Helpdesk services' and/or 'Management of billable works'"
        end

        context 'when another service is included as well' do
          before { choose_services.service_codes << 'L.1' }

          it 'is valid' do
            expect(choose_services.valid?).to be true
          end
        end
      end

      context 'when the only codes are Q.3 and S.1' do
        let(:service_codes) { %w[Q.3 S.1] }

        it 'is not valid and has the correct error message' do
          expect(choose_services.valid?).to be false
          expect(choose_services.errors[:service_codes].first).to eq "You must select another service to include 'CAFM system', 'Helpdesk services' and/or 'Management of billable works'"
        end

        context 'when another service is included as well' do
          before { choose_services.service_codes << 'M.1' }

          it 'is valid' do
            expect(choose_services.valid?).to be true
          end
        end
      end

      context 'when the only codes are S.1 and R.1' do
        let(:service_codes) { %w[S.1 R.1] }

        it 'is not valid and has the correct error message' do
          expect(choose_services.valid?).to be false
          expect(choose_services.errors[:service_codes].first).to eq "You must select another service to include 'CAFM system', 'Helpdesk services' and/or 'Management of billable works'"
        end

        context 'when another service is included as well' do
          before { choose_services.service_codes << 'J.2' }

          it 'is valid' do
            expect(choose_services.valid?).to be true
          end
        end
      end

      context 'when the only codes are Q.3, S.1 and R.1' do
        let(:service_codes) { %w[Q.3 S.1 R.1] }

        it 'is not valid and has the correct error message' do
          expect(choose_services.valid?).to be false
          expect(choose_services.errors[:service_codes].first).to eq "You must select another service to include 'CAFM system', 'Helpdesk services' and/or 'Management of billable works'"
        end

        context 'when another service is included as well' do
          before { choose_services.service_codes << 'K.2' }

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
      expect(choose_services.next_step_class).to be FacilitiesManagement::RM6232::Journey::ChooseLocations
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
end
