require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6232::Journey::ChooseServices, type: :model do
  let(:choose_services) { described_class.new(service_codes: service_codes, region_codes: region_codes, sector_code: sector_code, contract_cost: etimated_contract_cost) }
  let(:service_codes) { %w[E.1 E.2] }
  let(:region_codes) {  %w[UKC1 UKC2] }
  let(:sector_code) { 3 }
  let(:etimated_contract_cost) { 123_456 }

  describe 'validations' do
    context 'when no service codes are present' do
      let(:service_codes) { [] }

      it 'is not valid and has the correct error message' do
        expect(choose_services.valid?).to be false
        expect(choose_services.errors[:service_codes].first).to eq 'Select at least one service you need to include in your procurement'
      end
    end

    context 'when both Mobile and Routine cleaning are selected' do
      let(:service_codes) { %w[I.1 I.4] }

      it 'is not valid and has the correct error message' do
        expect(choose_services.valid?).to be false
        expect(choose_services.errors[:service_codes].first).to eq "'Mobile cleaning' and 'Routine cleaning' are the same, but differ by delivery method. Please choose one of these services only"
      end
    end

    # rubocop:disable RSpec/NestedGroups
    context 'when validateing that not all services are mandatory' do
      context 'when the only code is P.1' do
        let(:service_codes) { %w[P.1] }

        it 'is not valid and has the correct error message' do
          expect(choose_services.valid?).to be false
          expect(choose_services.errors[:service_codes].first).to eq "You must select another service to include 'CAFM system', 'Helpdesk services' and/or 'Management of billable works'"
        end

        context 'when another service is included as well' do
          before { choose_services.service_codes << 'H.1' }

          it 'will be valid' do
            expect(choose_services.valid?).to be true
          end
        end
      end

      context 'when the only code is P.2' do
        let(:service_codes) { %w[P.2] }

        it 'is not valid and has the correct error message' do
          expect(choose_services.valid?).to be false
          expect(choose_services.errors[:service_codes].first).to eq "You must select another service to include 'CAFM system', 'Helpdesk services' and/or 'Management of billable works'"
        end

        context 'when another service is included as well' do
          before { choose_services.service_codes << 'I.1' }

          it 'will be valid' do
            expect(choose_services.valid?).to be true
          end
        end
      end

      context 'when the only code is Q.1' do
        let(:service_codes) { %w[Q.1] }

        it 'is not valid and has the correct error message' do
          expect(choose_services.valid?).to be false
          expect(choose_services.errors[:service_codes].first).to eq "You must select another service to include 'CAFM system', 'Helpdesk services' and/or 'Management of billable works'"
        end

        context 'when another service is included as well' do
          before { choose_services.service_codes << 'J.1' }

          it 'will be valid' do
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
          before { choose_services.service_codes << 'K.1' }

          it 'will be valid' do
            expect(choose_services.valid?).to be true
          end
        end
      end

      context 'when the only codes are P.1 and Q.1' do
        let(:service_codes) { %w[P.1 Q.1] }

        it 'is not valid and has the correct error message' do
          expect(choose_services.valid?).to be false
          expect(choose_services.errors[:service_codes].first).to eq "You must select another service to include 'CAFM system', 'Helpdesk services' and/or 'Management of billable works'"
        end

        context 'when another service is included as well' do
          before { choose_services.service_codes << 'L.1' }

          it 'will be valid' do
            expect(choose_services.valid?).to be true
          end
        end
      end

      context 'when the only codes are P.1 and R.1' do
        let(:service_codes) { %w[P.1 R.1] }

        it 'is not valid and has the correct error message' do
          expect(choose_services.valid?).to be false
          expect(choose_services.errors[:service_codes].first).to eq "You must select another service to include 'CAFM system', 'Helpdesk services' and/or 'Management of billable works'"
        end

        context 'when another service is included as well' do
          before { choose_services.service_codes << 'M.1' }

          it 'will be valid' do
            expect(choose_services.valid?).to be true
          end
        end
      end

      context 'when the only codes are P.2 and Q.1' do
        let(:service_codes) { %w[P.2 Q.1] }

        it 'is not valid and has the correct error message' do
          expect(choose_services.valid?).to be false
          expect(choose_services.errors[:service_codes].first).to eq "You must select another service to include 'CAFM system', 'Helpdesk services' and/or 'Management of billable works'"
        end

        context 'when another service is included as well' do
          before { choose_services.service_codes << 'N.1' }

          it 'will be valid' do
            expect(choose_services.valid?).to be true
          end
        end
      end

      context 'when the only codes are P.2 and R.1' do
        let(:service_codes) { %w[P.2 R.1] }

        it 'is not valid and has the correct error message' do
          expect(choose_services.valid?).to be false
          expect(choose_services.errors[:service_codes].first).to eq "You must select another service to include 'CAFM system', 'Helpdesk services' and/or 'Management of billable works'"
        end

        context 'when another service is included as well' do
          before { choose_services.service_codes << 'H.2' }

          it 'will be valid' do
            expect(choose_services.valid?).to be true
          end
        end
      end

      context 'when the only codes are R.1 and Q.1' do
        let(:service_codes) { %w[R.1 Q.1] }

        it 'is not valid and has the correct error message' do
          expect(choose_services.valid?).to be false
          expect(choose_services.errors[:service_codes].first).to eq "You must select another service to include 'CAFM system', 'Helpdesk services' and/or 'Management of billable works'"
        end

        context 'when another service is included as well' do
          before { choose_services.service_codes << 'J.2' }

          it 'will be valid' do
            expect(choose_services.valid?).to be true
          end
        end
      end

      context 'when the only codes are P.1, R.1 and Q.1' do
        let(:service_codes) { %w[P.1 R.1 Q.1] }

        it 'is not valid and has the correct error message' do
          expect(choose_services.valid?).to be false
          expect(choose_services.errors[:service_codes].first).to eq "You must select another service to include 'CAFM system', 'Helpdesk services' and/or 'Management of billable works'"
        end

        context 'when another service is included as well' do
          before { choose_services.service_codes << 'K.2' }

          it 'will be valid' do
            expect(choose_services.valid?).to be true
          end
        end
      end

      context 'when the only codes are P.2, R.1 and Q.1' do
        let(:service_codes) { %w[P.2 R.1 Q.1] }

        it 'is not valid and has the correct error message' do
          expect(choose_services.valid?).to be false
          expect(choose_services.errors[:service_codes].first).to eq "You must select another service to include 'CAFM system', 'Helpdesk services' and/or 'Management of billable works'"
        end

        context 'when another service is included as well' do
          before { choose_services.service_codes << 'L.2' }

          it 'will be valid' do
            expect(choose_services.valid?).to be true
          end
        end
      end
    end
    # rubocop:enable RSpec/NestedGroups

    context 'when validating CAFM' do
      context 'and both P.1 and P.2 have been selected' do
        let(:service_codes) { %w[E.1 P.1 P.2] }

        it 'is not valid and has the correct error message' do
          expect(choose_services.valid?).to be false
          expect(choose_services.errors[:service_codes].first).to eq 'Select only one CAFM service'
        end
      end

      context 'and P.1 has been selected with only hard services' do
        let(:service_codes) { %w[E.1 E.2 P.1] }

        it 'is not valid and has the correct error message' do
          expect(choose_services.valid?).to be false
          expect(choose_services.errors[:service_codes].first).to eq "'Generic CAFM Services' can only be selected when all other services are of type Soft FM"
        end
      end

      context 'and P.1 has been selected with hard and soft services' do
        let(:service_codes) { %w[F.1 F.2 H.1 H.2 P.1] }

        it 'is not valid and has the correct error message' do
          expect(choose_services.valid?).to be false
          expect(choose_services.errors[:service_codes].first).to eq "'Generic CAFM Services' can only be selected when all other services are of type Soft FM"
        end
      end

      context 'and P.1 has been selected with only total services' do
        let(:service_codes) { %w[O.1 O.2 O.3 P.1] }

        it 'is not valid and has the correct error message' do
          expect(choose_services.valid?).to be false
          expect(choose_services.errors[:service_codes].first).to eq "'Generic CAFM Services' can only be selected when all other services are of type Soft FM"
        end
      end

      context 'and P.1 has been selected with only landscaping services' do
        let(:service_codes) { %w[G.1 G.3 G.5 G.7 P.1 R.1] }

        it 'is valid' do
          expect(choose_services.valid?).to be true
        end
      end

      context 'and P.1 has been selected with hard and landscaping services' do
        let(:service_codes) { %w[E.1 G.2 G.4 G.6 G.8 P.1 Q.1] }

        it 'is not valid and has the correct error message' do
          expect(choose_services.valid?).to be false
          expect(choose_services.errors[:service_codes].first).to eq "'Generic CAFM Services' can only be selected when all other services are of type Soft FM"
        end
      end
    end

    context 'when service codes are present' do
      it 'is valid' do
        expect(choose_services.valid?).to be true
      end
    end
  end

  describe '.work_packages' do
    it 'returns all the selectable work packages' do
      expect(choose_services.work_packages.map(&:code)).to eq %w[E F G H I J K L M N O P Q R]
    end
  end

  describe '.next_step_class' do
    it 'returns Journey::ChooseLocations' do
      expect(choose_services.next_step_class).to be FacilitiesManagement::RM6232::Journey::ChooseLocations
    end
  end

  describe '.permit_list' do
    it 'returns a list of the permitted attributes' do
      expect(described_class.permit_list).to eq [:sector_code, :contract_cost, { service_codes: [], region_codes: [] }]
    end
  end

  describe '.permitted_keys' do
    it 'returns a list of the permitted keys' do
      expect(described_class.permitted_keys).to eq %i[service_codes region_codes sector_code contract_cost]
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
