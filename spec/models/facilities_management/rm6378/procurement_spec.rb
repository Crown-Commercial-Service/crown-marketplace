require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6378::Procurement do
  describe 'service_ids' do
    let(:procurement) { create(:facilities_management_rm6378_procurement, procurement_details:) }

    context 'when getting the data' do
      context 'when the procurement_details is nil' do
        let(:procurement_details) { nil }

        it 'returns an empty array' do
          expect(procurement.service_ids).to eq([])
        end
      end

      context 'when the procurement_details is empty' do
        let(:procurement_details) { {} }

        it 'returns an empty array' do
          expect(procurement.service_ids).to eq([])
        end
      end

      context 'when the procurement_details contains the service ids' do
        let(:procurement_details) { { 'service_ids' => ['RM6378.1a.E1', 'RM6378.1a.E2'] } }

        it 'gets ther service ids from the procurement_details' do
          expect(procurement.service_ids).to eq(['RM6378.1a.E1', 'RM6378.1a.E2'])
        end
      end
    end

    context 'when setting the data' do
      context 'when the procurement_details is nil' do
        let(:procurement_details) { nil }

        it 'sets the procurement_details with service ids' do
          procurement.service_ids = ['RM6378.1a.E3', 'RM6378.1a.E4']

          expect(procurement.procurement_details).to eq({ 'service_ids' => ['RM6378.1a.E3', 'RM6378.1a.E4'] })
        end
      end

      context 'when the procurement_details is empty' do
        let(:procurement_details) { {} }

        it 'sets the procurement_details with service ids' do
          procurement.service_ids = ['RM6378.1a.E3', 'RM6378.1a.E4']

          expect(procurement.procurement_details).to eq({ 'service_ids' => ['RM6378.1a.E3', 'RM6378.1a.E4'] })
        end
      end

      context 'when the procurement_details contains the service ids' do
        let(:procurement_details) { { 'service_ids' => ['RM6378.1a.E1', 'RM6378.1a.E2'], 'something' => 'else' } }

        it 'updates the procurement_details with service ids' do
          procurement.service_ids = ['RM6378.1a.E3', 'RM6378.1a.E4']

          expect(procurement.procurement_details).to eq({ 'service_ids' => ['RM6378.1a.E3', 'RM6378.1a.E4'], 'something' => 'else' })
        end
      end
    end
  end

  describe 'jurisdiction_ids' do
    let(:procurement) { create(:facilities_management_rm6378_procurement, procurement_details:) }

    context 'when getting the data' do
      context 'when the procurement_details is nil' do
        let(:procurement_details) { nil }

        it 'returns an empty array' do
          expect(procurement.jurisdiction_ids).to eq([])
        end
      end

      context 'when the procurement_details is empty' do
        let(:procurement_details) { {} }

        it 'returns an empty array' do
          expect(procurement.jurisdiction_ids).to eq([])
        end
      end

      context 'when the procurement_details contains the jurisdiction ids' do
        let(:procurement_details) { { 'jurisdiction_ids' => ['TLH3', 'TLH5'] } }

        it 'gets ther jurisdiction ids from the procurement_details' do
          expect(procurement.jurisdiction_ids).to eq(['TLH3', 'TLH5'])
        end
      end
    end

    context 'when setting the data' do
      context 'when the procurement_details is nil' do
        let(:procurement_details) { nil }

        it 'sets the procurement_details with jurisdiction ids' do
          procurement.jurisdiction_ids = ['TLH2', 'TLH4']

          expect(procurement.procurement_details).to eq({ 'jurisdiction_ids' => ['TLH2', 'TLH4'] })
        end
      end

      context 'when the procurement_details is empty' do
        let(:procurement_details) { {} }

        it 'sets the procurement_details with jurisdiction ids' do
          procurement.jurisdiction_ids = ['TLH2', 'TLH4']

          expect(procurement.procurement_details).to eq({ 'jurisdiction_ids' => ['TLH2', 'TLH4'] })
        end
      end

      context 'when the procurement_details contains the jurisdiction ids' do
        let(:procurement_details) { { 'jurisdiction_ids' => ['TLH3', 'TLH5'], 'something' => 'else' } }

        it 'updates the procurement_details with jurisdiction ids' do
          procurement.jurisdiction_ids = ['TLH2', 'TLH4']

          expect(procurement.procurement_details).to eq({ 'jurisdiction_ids' => ['TLH2', 'TLH4'], 'something' => 'else' })
        end
      end
    end
  end

  describe 'annual_contract_value' do
    let(:procurement) { create(:facilities_management_rm6378_procurement, procurement_details:) }

    context 'when getting the data' do
      context 'when the procurement_details is nil' do
        let(:procurement_details) { nil }

        it 'returns nil' do
          expect(procurement.annual_contract_value).to be_nil
        end
      end

      context 'when the procurement_details is empty' do
        let(:procurement_details) { {} }

        it 'returns nil' do
          expect(procurement.annual_contract_value).to be_nil
        end
      end

      context 'when the procurement_details contains the annual contract value' do
        let(:procurement_details) { { 'annual_contract_value' => 123_456 } }

        it 'gets ther annual contract value from the procurement_details' do
          expect(procurement.annual_contract_value).to eq(123_456)
        end
      end
    end

    context 'when setting the data' do
      context 'when the procurement_details is nil' do
        let(:procurement_details) { nil }

        it 'sets the procurement_details with annual contract value' do
          procurement.annual_contract_value = 456_123

          expect(procurement.procurement_details).to eq({ 'annual_contract_value' => 456_123 })
        end
      end

      context 'when the procurement_details is empty' do
        let(:procurement_details) { {} }

        it 'sets the procurement_details with annual contract value' do
          procurement.annual_contract_value = 456_123

          expect(procurement.procurement_details).to eq({ 'annual_contract_value' => 456_123 })
        end
      end

      context 'when the procurement_details contains the annual contract value' do
        let(:procurement_details) { { 'annual_contract_value' => 123_456, 'something' => 'else' } }

        it 'updates the procurement_details with annual contract value' do
          procurement.annual_contract_value = 456_123

          expect(procurement.procurement_details).to eq({ 'annual_contract_value' => 456_123, 'something' => 'else' })
        end
      end
    end
  end

  describe 'requirements_linked_to_pfi' do
    let(:procurement) { create(:facilities_management_rm6378_procurement, procurement_details:) }

    context 'when getting the data' do
      context 'when the procurement_details is nil' do
        let(:procurement_details) { nil }

        it 'returns nil' do
          expect(procurement.requirements_linked_to_pfi).to be_nil
        end
      end

      context 'when the procurement_details is empty' do
        let(:procurement_details) { {} }

        it 'returns nil' do
          expect(procurement.requirements_linked_to_pfi).to be_nil
        end
      end

      context 'when the procurement_details contains the requirements linked to pfi' do
        let(:procurement_details) { { 'requirements_linked_to_pfi' => false } }

        it 'gets ther requirements linked to pfi from the procurement_details' do
          expect(procurement.requirements_linked_to_pfi).to be(false)
        end
      end
    end

    context 'when setting the data' do
      context 'when the procurement_details is nil' do
        let(:procurement_details) { nil }

        it 'sets the procurement_details with requirements linked to pfi' do
          procurement.requirements_linked_to_pfi = false

          expect(procurement.procurement_details).to eq({ 'requirements_linked_to_pfi' => false })
        end
      end

      context 'when the procurement_details is empty' do
        let(:procurement_details) { {} }

        it 'sets the procurement_details with requirements linked to pfi' do
          procurement.requirements_linked_to_pfi = false

          expect(procurement.procurement_details).to eq({ 'requirements_linked_to_pfi' => false })
        end
      end

      context 'when the procurement_details contains the requirements linked to pfi' do
        let(:procurement_details) { { 'requirements_linked_to_pfi' => true, 'something' => 'else' } }

        it 'updates the procurement_details with requirements linked to pfi' do
          procurement.requirements_linked_to_pfi = false

          expect(procurement.procurement_details).to eq({ 'requirements_linked_to_pfi' => false, 'something' => 'else' })
        end
      end
    end
  end

  describe '.suppliers' do
    let(:procurement) { create(:facilities_management_rm6378_procurement, procurement_details: { 'service_ids' => service_ids, 'jurisdiction_ids' => jurisdiction_ids }) }
    let(:result) { procurement.suppliers.pluck('supplier.name') }
    let(:suppliers) do
      [
        create(:supplier, name: 'Supplier 3'),
        create(:supplier, name: 'Supplier 2'),
        create(:supplier, name: 'Supplier 5'),
        create(:supplier, name: 'Supplier 1'),
        create(:supplier, name: 'Supplier 4')
      ]
    end
    let(:supplier_frameworks) { suppliers.map { |supplier| create(:supplier_framework, framework_id: 'RM6378', supplier: supplier) } }
    let(:supplier_framework_1_id) { supplier_frameworks[0].id }
    let(:supplier_framework_2_id) { supplier_frameworks[1].id }
    let(:supplier_framework_3_id) { supplier_frameworks[2].id }

    before do
      supplier_frameworks[3].update(enabled: false)

      supplier_framework_1_lot_a = create(:supplier_framework_lot, supplier_framework: supplier_frameworks[0], lot_id: 'RM6378.1a')
      supplier_framework_2_lot_a = create(:supplier_framework_lot, supplier_framework: supplier_frameworks[1], lot_id: 'RM6378.1a')
      supplier_framework_3_lot_a = create(:supplier_framework_lot, supplier_framework: supplier_frameworks[2], lot_id: 'RM6378.1a')
      supplier_framework_4_lot_a = create(:supplier_framework_lot, supplier_framework: supplier_frameworks[3], lot_id: 'RM6378.1a')
      supplier_framework_5_lot_a = create(:supplier_framework_lot, supplier_framework: supplier_frameworks[4], lot_id: 'RM6378.1a', enabled: false)

      create(:supplier_framework_lot_service, supplier_framework_lot: supplier_framework_1_lot_a, service_id: 'RM6378.1a.E1')
      create(:supplier_framework_lot_service, supplier_framework_lot: supplier_framework_2_lot_a, service_id: 'RM6378.1a.E1')
      create(:supplier_framework_lot_service, supplier_framework_lot: supplier_framework_3_lot_a, service_id: 'RM6378.1a.E1')
      create(:supplier_framework_lot_service, supplier_framework_lot: supplier_framework_4_lot_a, service_id: 'RM6378.1a.E1')
      create(:supplier_framework_lot_service, supplier_framework_lot: supplier_framework_5_lot_a, service_id: 'RM6378.1a.E1')

      create(:supplier_framework_lot_service, supplier_framework_lot: supplier_framework_1_lot_a, service_id: 'RM6378.1a.E2')
      create(:supplier_framework_lot_service, supplier_framework_lot: supplier_framework_2_lot_a, service_id: 'RM6378.1a.E2')

      create(:supplier_framework_lot_service, supplier_framework_lot: supplier_framework_2_lot_a, service_id: 'RM6378.1a.E3')
      create(:supplier_framework_lot_service, supplier_framework_lot: supplier_framework_3_lot_a, service_id: 'RM6378.1a.E3')

      create(:supplier_framework_lot_service, supplier_framework_lot: supplier_framework_3_lot_a, service_id: 'RM6378.1a.E4')

      create(:supplier_framework_lot_jurisdiction, supplier_framework_lot: supplier_framework_1_lot_a, jurisdiction_id: 'TLH3')
      create(:supplier_framework_lot_jurisdiction, supplier_framework_lot: supplier_framework_2_lot_a, jurisdiction_id: 'TLH3')
      create(:supplier_framework_lot_jurisdiction, supplier_framework_lot: supplier_framework_2_lot_a, jurisdiction_id: 'TLK4')
      create(:supplier_framework_lot_jurisdiction, supplier_framework_lot: supplier_framework_3_lot_a, jurisdiction_id: 'TLH3')
      create(:supplier_framework_lot_jurisdiction, supplier_framework_lot: supplier_framework_3_lot_a, jurisdiction_id: 'TLK4')
      create(:supplier_framework_lot_jurisdiction, supplier_framework_lot: supplier_framework_4_lot_a, jurisdiction_id: 'TLH3')
      create(:supplier_framework_lot_jurisdiction, supplier_framework_lot: supplier_framework_5_lot_a, jurisdiction_id: 'TLH3')
    end

    context 'when we pass a single service code and jurisdiction id' do
      let(:service_ids) { ['RM6378.1a.E1'] }
      let(:jurisdiction_ids) { ['TLH3'] }

      it 'returns three suppliers' do
        expect(result).to eq(['Supplier 2', 'Supplier 3', 'Supplier 5'])
      end
    end

    context 'when we pass multiple service codes and a single jurisdiction id' do
      let(:service_ids) { ['RM6378.1a.E1', 'RM6378.1a.E2'] }
      let(:jurisdiction_ids) { ['TLH3'] }

      it 'returns the first and second suppliers' do
        expect(result).to eq(['Supplier 2', 'Supplier 3'])
      end
    end

    context 'when we pass multiple jurisdiction ids and single service ids' do
      let(:service_ids) { ['RM6378.1a.E1'] }
      let(:jurisdiction_ids) { ['TLH3', 'TLK4'] }

      it 'returns the second and third suppliers' do
        expect(result).to eq(['Supplier 2', 'Supplier 5'])
      end
    end

    context 'when we pass multiple service codes and a multiple jurisdiction ids' do
      let(:service_ids) { ['RM6378.1a.E3', 'RM6378.1a.E4'] }
      let(:jurisdiction_ids) { ['TLH3', 'TLK4'] }

      it 'returns the third supplier' do
        expect(result).to eq(['Supplier 5'])
      end
    end

    context 'when we pass service codes neither supplier does' do
      let(:service_ids) { ['RM6378.2a.1'] }
      let(:jurisdiction_ids) { ['TLH3'] }

      it 'returns an emoty array' do
        expect(result).to be_empty
      end
    end

    context 'when we pass jurisdictions neither supplier does' do
      let(:service_ids) { ['RM6378.1a.E1'] }
      let(:jurisdiction_ids) { ['DE'] }

      it 'returns an emoty array' do
        expect(result).to be_empty
      end
    end
  end

  describe 'services' do
    let(:procurement) { create(:facilities_management_rm6378_procurement, procurement_details:) }

    it 'returns the servies sorted by category then number' do
      procurement = create(:facilities_management_rm6378_procurement, procurement_details: { 'service_ids' => ['RM6378.1a.E1', 'RM6378.1a.E2', 'RM6378.1a.G5', 'RM6378.1a.G3', 'RM6378.1a.F1', 'RM6378.1a.I10', 'RM6378.1a.I1', 'RM6378.1a.I12'] })

      expect(procurement.services.pluck(:id)).to eq(['RM6378.1a.E1', 'RM6378.1a.E2', 'RM6378.1a.F1', 'RM6378.1a.G3', 'RM6378.1a.G5', 'RM6378.1a.I1', 'RM6378.1a.I10', 'RM6378.1a.I12'])
    end
  end

  describe 'jurisdictions' do
    let(:procurement) { create(:facilities_management_rm6378_procurement, procurement_details:) }

    it 'returns the jurisdictions sorted by category then number' do
      procurement = create(:facilities_management_rm6378_procurement, procurement_details: { 'jurisdiction_ids' => ['TLD3', 'TLD1', 'TLN0D', 'TLN0A', 'TLN06', 'TLG2'] })

      expect(procurement.jurisdictions.pluck(:id)).to eq(['TLD1', 'TLD3', 'TLG2', 'TLN06', 'TLN0A', 'TLN0D'])
    end
  end

  describe 'validations' do
    describe 'contract_name' do
      let(:procurement) { build(:facilities_management_rm6378_procurement, user:, framework:) }
      let(:user) { create(:user) }
      let(:framework) { create(:framework) }

      before { procurement.contract_name = contract_name }

      context 'when the name is more than 100 characters' do
        let(:contract_name) { (0...101).map { ('a'..'z').to_a.sample }.join }

        it 'is expected to not be valid and has the correct error message' do
          expect(procurement.valid?(:contract_name)).to be false
          expect(procurement.errors[:contract_name].first).to eq 'Your contract name must be 100 characters or fewer'
        end
      end

      context 'when the name is nil' do
        let(:contract_name) { nil }

        it 'is expected to not be valid and has the correct error message' do
          expect(procurement.valid?(:contract_name)).to be false
          expect(procurement.errors[:contract_name].first).to eq 'Enter your contract name'
        end
      end

      context 'when the name is empty' do
        let(:contract_name) { '' }

        it 'is expected to not be valid and has the correct error message' do
          expect(procurement.valid?(:contract_name)).to be false
          expect(procurement.errors[:contract_name].first).to eq 'Enter your contract name'
        end
      end

      context 'when the name is taken by the same user' do
        let(:contract_name) { 'My taken name' }

        it 'is expected to not be valid and has the correct error message' do
          create(:facilities_management_rm6378_procurement, user:, framework:, contract_name:)

          expect(procurement.valid?(:contract_name)).to be false
          expect(procurement.errors[:contract_name].first).to eq 'This contract name is already in use'
        end
      end

      context 'when the name is in use on a different frameworks' do
        let(:contract_name) { 'My taken name' }

        it 'is valid' do
          create(:facilities_management_rm6378_procurement, user: user, framework: create(:framework), contract_name: contract_name)

          expect(procurement.valid?(:contract_name)).to be true
        end
      end

      context 'when the name is taken by the a different user' do
        let(:contract_name) { 'My taken name' }

        it 'is valid' do
          create(:facilities_management_rm6378_procurement, user: create(:user), framework: framework, contract_name: contract_name)

          expect(procurement.valid?(:contract_name)).to be true
        end
      end

      context 'when the name is correct' do
        let(:contract_name) { 'Valid Name' }

        it 'expected to be valid' do
          expect(procurement.valid?(:contract_name)).to be true
        end
      end
    end

    describe 'requirements_linked_to_pfi' do
      let(:procurement) { build(:facilities_management_rm6378_procurement, user:) }
      let(:user) { create(:user) }

      before { procurement.requirements_linked_to_pfi = requirements_linked_to_pfi }

      context 'when requirements_linked_to_pfi is nil' do
        let(:requirements_linked_to_pfi) { nil }

        it 'is expected to not be valid and has the correct error message' do
          expect(procurement.valid?(:contract_name)).to be false
          expect(procurement.errors[:requirements_linked_to_pfi].first).to eq 'Select one option for requirements linked to PFI'
        end
      end

      context 'when the requirements_linked_to_pfi is empty' do
        let(:requirements_linked_to_pfi) { '' }

        it 'is expected to not be valid and has the correct error message' do
          expect(procurement.valid?(:contract_name)).to be false
          expect(procurement.errors[:requirements_linked_to_pfi].first).to eq 'Select one option for requirements linked to PFI'
        end
      end

      [true, false].each do |option|
        context "when the requirements_linked_to_pfi is #{option}" do
          let(:requirements_linked_to_pfi) { option }

          it 'expected to be valid' do
            expect(procurement.valid?(:contract_name)).to be true
          end
        end
      end
    end
  end

  describe '.update_contract_name_with_security' do
    let(:user) { create(:user) }
    let(:procurement) { create(:facilities_management_rm6378_procurement, user: user, contract_name: 'Hornet') }

    context 'when the user has no other procurements with the same name' do
      it 'sets the name to Hornet (Security)' do
        procurement.update_contract_name_with_security

        expect(procurement.contract_name).to eq('Hornet (Security)')
      end
    end

    context 'when the user has other procurements with a different name' do
      before { create(:facilities_management_rm6378_procurement, user: user, contract_name: 'The Knight') }

      it 'sets the name to Hornet (Security)' do
        procurement.update_contract_name_with_security

        expect(procurement.contract_name).to eq('Hornet (Security)')
      end
    end

    context 'when a different user has a procurement with the same name' do
      before { create(:facilities_management_rm6378_procurement, user: create(:user), contract_name: 'Hornet') }

      it 'sets the name to Hornet (Security)' do
        procurement.update_contract_name_with_security

        expect(procurement.contract_name).to eq('Hornet (Security)')
      end
    end

    context 'when the user has a procurement with the same name in a different framework' do
      before { create(:procurement, user: user, framework: create(:framework), contract_name: 'Hornet') }

      it 'sets the name to Hornet (Security)' do
        procurement.update_contract_name_with_security

        expect(procurement.contract_name).to eq('Hornet (Security)')
      end
    end

    context 'when the user has a procurement with the same name' do
      before { create(:facilities_management_rm6378_procurement, user: user, contract_name: 'Hornet (Security)') }

      it 'sets the name to Hornet (Security 1)' do
        procurement.update_contract_name_with_security

        expect(procurement.contract_name).to eq('Hornet (Security 1)')
      end
    end

    context 'when the user has a procurement with the same name a few times' do
      before do
        create(:facilities_management_rm6378_procurement, user: user, contract_name: 'Hornet (Security)')
        99.times { |number| create(:facilities_management_rm6378_procurement, user: user, contract_name: "Hornet (Security #{number + 1})") }
      end

      it 'sets the name to Hornet (Security 100)' do
        procurement.update_contract_name_with_security

        expect(procurement.contract_name).to eq('Hornet (Security 100)')
      end
    end

    context 'when the user has a procurement with the same name 100 times' do
      before do
        create(:facilities_management_rm6378_procurement, user: user, contract_name: 'Hornet (Security)')
        100.times { |number| create(:facilities_management_rm6378_procurement, user: user, contract_name: "Hornet (Security #{number + 1})") }
      end

      it 'raises a CannotCreateNameError' do
        expect { procurement.update_contract_name_with_security }.to raise_error(FacilitiesManagement::RM6378::Procurement::CannotCreateNameError)
      end
    end
  end

  describe 'create callbakcs' do
    let(:procurement) { build(:facilities_management_rm6378_procurement_base) }
    let(:contract_number_generator_stub) { instance_double(FacilitiesManagement::ContractNumberGenerator) }

    before do
      allow(FacilitiesManagement::ContractNumberGenerator).to receive(:new).with(framework: 'RM6378', model: described_class).and_return(contract_number_generator_stub)
      allow(contract_number_generator_stub).to receive(:new_number).and_return('RM0161-0161-20251001')
    end

    it 'generates a contract number' do
      expect(procurement.contract_number).to be_nil

      procurement.save

      expect(procurement.contract_number).to eq('RM0161-0161-20251001')
    end
  end
end
